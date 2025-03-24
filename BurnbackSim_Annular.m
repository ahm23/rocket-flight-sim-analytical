%% Solve for Mach @ Nozzle Exit
syms Me
eqn = params.AeAt == (1/Me) * ((2/(params.fuel.SHR+1))*(1+(Me^2)*(params.fuel.SHR-1)/2))^((params.fuel.SHR+1)/(2*(params.fuel.SHR-1)));
exitMach = vpasolve(eqn, Me, [0 10]);

%% Annular Grain Burnback
%%% Initial Conditions
if grain.lenCruise > 0
    base = true;
else
    base = false;
end
base = true;
P0    = Pinf * (1+(params.fuel.SHR-1)/2)^(params.fuel.SHR/(params.fuel.SHR-1));           % [Pa], for example
X0    = [ P0; grain.r_in; grain.lenAccel ];   % combine into the state vector
%%% Simulate Burnback (Analytical)
tspan = [0, 30];
[tSol, XSol] = ode45(@(t,X) RocketSystem_Annular(t, X, params, base), tspan, X0, odeset('Events', @(t,X) EVENT_ACCELPHASECOMPLETE(t, X, params.r_max)));
tSol1 = tSol;
%%% Unpack Results
sln_P   = XSol(:,1);   % pressure over time
sln_r   = XSol(:,2);   % inner radius over time
sln_L   = XSol(:,3);   % grain length over time
sln_m = params.fuel.Density * ((pi*params.r_max^2 - pi*sln_r.^2) .* sln_L + pi*params.r_max^2 * grain.lenCruise);

%%% Proof that can estimate max pressure
%P0Estimate = (fuel.getCV()*fuel.Density*fuel.TCoefficient*(2*pi*params.r_max*grain.lenAccel)/params.At)^(1/(1-fuel.Stability))
%disp(sln_P(end))

%% Cylindrical Base Grain Burnback
if grain.lenCruise > 0
    %%% Initial Conditions
    P0      = sln_P(end);           % [Pa]
    X0      = [ P0; grain.lenCruise ];   % combine into the state vector
    %%% Simulate Burnback (Analytical)
    tspan   = [tSol(end), 50];
    [tSol2, XSol2] = ode45(@(t,X) RocketSystem_Cylinder(t, X, params), tspan, X0, odeset('Events', @(t,X) EVENT_CRUISEPHASECOMPLETE(t, X, 0)));
    %%% Unpack Results
    sln_P   = [sln_P; XSol2(:,1)];
    sln_L   = [sln_L; XSol2(:,2)];
    sln_m   = [sln_m; params.fuel.Density * pi*params.r_max^2 .* XSol2(:,2)];
    tSol    = [tSol; tSol2];
end
%% Generate Thrust Curve
Pe = double(sln_P ./ (1 + (exitMach^2)*(params.fuel.SHR-1)/2)^(params.fuel.SHR/(params.fuel.SHR-1)));
mdot = (sln_P*params.At*sqrt(params.fuel.SHR)/sqrt(params.fuel.R*params.fuel.T0)) * ...
    (2 / (params.fuel.SHR + 1))^((params.fuel.SHR + 1) / (2 * (params.fuel.SHR - 1)));
ue = sqrt((2*params.fuel.SHR*params.fuel.R*params.fuel.T0/(params.fuel.SHR-1)) * ...
    (1-(Pe./sln_P).^((params.fuel.SHR-1)/params.fuel.SHR)));

thrust = double(mdot.*ue + params.At*params.AeAt * (Pe - Pinf));

%% Solve for Mach @ Nozzle Exit
%syms PE
%eqn = 1/(((PE/343332)^(1/fuel.SHR)) ...
%    * sqrt((2/(fuel.SHR-1))*((fuel.SHR+1)/2)^((fuel.SHR+1)/(fuel.SHR-1)) ...
%    * (1-(PE/343332)^((fuel.SHR-1)/fuel.SHR)))) - params.AeAt;
%exitP = vpasolve(eqn, PE)

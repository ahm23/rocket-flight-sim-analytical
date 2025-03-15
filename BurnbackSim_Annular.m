%% Solve for Mach @ Nozzle Exit
syms Me
eqn = (1/Me) * ((2/(params.gamma+1))*(1+Me^2*(params.gamma-1)/2))^((params.gamma+1)/(2*(params.gamma-1))) - params.AeAt;
exitMach = vpasolve(eqn, Me);

%% Annular Grain Burnback
%%% Initial Conditions
if grain.len2 > 0
    base = true;
else
    base = false;
end
P0    = Pinf * (1+(params.gamma-1)/2)^(params.gamma/(params.gamma-1));           % [Pa], for example
X0    = [ P0; grain.r_in; grain.len1 ];   % combine into the state vector
%%% Simulate Burnback (Analytical)
tspan = [0, 30];
[tSol, XSol] = ode45(@(t,X) RocketSystem_Annular(t, X, params, base), tspan, X0, odeset('Events', @(t,X) EVENT_ACCELPHASECOMPLETE(t, X, params.r_max)));
tSol1 = tSol;
%%% Unpack Results
sln_P   = XSol(:,1);   % pressure over time
sln_r   = XSol(:,2);   % inner radius over time
sln_L   = XSol(:,3);   % grain length over time
sln_m = params.rho * ((pi*params.r_max^2 - pi*sln_r.^2) .* sln_L + pi*params.r_max^2 * grain.len2);
%% Cylindrical Base Grain Burnback
if grain.len2 > 0
    %%% Initial Conditions
    P0      = sln_P(end);           % [Pa]
    X0      = [ P0; grain.len2 ];   % combine into the state vector
    %%% Simulate Burnback (Analytical)
    tspan   = [tSol(end), 50];
    [tSol2, XSol2] = ode45(@(t,X) RocketSystem_Cylinder(t, X, params), tspan, X0, odeset('Events', @(t,X) EVENT_CRUISEPHASECOMPLETE(t, X, 0)));
    %%% Unpack Results
    sln_P   = [sln_P; XSol2(:,1)];
    sln_L   = [sln_L; XSol2(:,2)];
    sln_m   = [sln_m; params.rho * pi*params.r_max^2 .* XSol2(:,2)];
    tSol    = [tSol; tSol2];
end
%% Generate Thrust Curve
Pe = double(sln_P ./ (1 + exitMach^2*(params.gamma-1)/2)^(params.gamma/(params.gamma-1)));
mdot = (sln_P*params.A_t*sqrt(params.gamma)/sqrt(params.R_*params.T0_)) * ...
    (2 / (params.gamma + 1))^((params.gamma + 1) / (2 * (params.gamma - 1)));
ue = sqrt((2*params.gamma*params.R_*params.T0_/(params.gamma-1)) * ...
    (1-(Pe./sln_P).^((params.gamma-1)/params.gamma)));

thrust = double(mdot.*ue + params.A_t*params.AeAt * (Pe - 4300));

%% Figures
%%% Pressure/Time
figure;
plot(tSol, sln_P./10^6, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Pressure [MPa]', 'FontSize', 14);
title('Chamber Pressure vs Time', 'FontSize', 14);
grid on;

%%% Thrust/Time
figure;
plot(tSol, thrust./1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Thrust [kN]', 'FontSize', 14);
title('Thrust vs Time', 'FontSize', 14);
grid on;

%%% Mass/Time
figure;
plot(tSol, sln_m, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Mass [kg]', 'FontSize', 14);
title('Mass vs Time', 'FontSize', 14);
grid on;

figure;
% --- Top subplot: Inner Radius ---
subplot(2,1,1);
plot(tSol1, sln_r, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('r_{in} [m]', 'FontSize', 12);
title('Inner Radius vs Time', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(2,1,2);
plot(tSol, sln_L, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('r_{in} [m]', 'FontSize', 12);
title('Grain Length vs Time', 'FontSize', 12);
grid on;
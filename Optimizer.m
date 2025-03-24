clear;
%% Variable Definition
%%% Initial Environment Parameters
H = 21336;
[~, a, Pinf, rho_atm] = atmosisa(H, extended=true);
g0 = 9.81;                      % Acceleration of Gravity [m/s^2]

%%% Target Mission Parameters
targetSpeed = 3 * a;            % Target Speed [m/s]

%%% Fuel & Exhaust Parameters
params.rho_g = 0.001;           % Exhaust Density [kg/m^3]
% HTPB - AP-80% Fe2O3-3%
FUELS(1) = RocketFuel("HTPB/AP[80%]/Fe2O3[3%]", 1854.55362, 3440, 1.25, 320, 0.52, 19.24*10^(-(3+6*0.52)));
% HTPB - AP-80%
FUELS(2) = RocketFuel("HTPB/AP[80%]", 1854.55362, 3440, 1.25, 320, 0.433, 10.19*10^(-(3+6*0.433)));
% HTPB - AP-75% Fe2O3-3%
FUELS(3) = RocketFuel("HTPB/AP[75%]/Fe2O3[3%]", 1854.55362, 3440, 1.25, 320, 0.323, 10.31*10^(-(3+6*0.323)));
% HTPB - AP-75%
FUELS(4) = RocketFuel("HTPB/AP[75%]", 1854.55362, 3440, 1.25, 320, 0.136, 5.02*10^(-(3+6*0.136)));
% HTPB - AP-70%
FUELS(5) = RocketFuel("HTPB/AP[70%]", 1854.55362, 3440, 1.25, 320, 0.098, 6.2*10^(-(3+6*0.098)));
% 2021 Custom
FUELS(6) = RocketFuel("HTPB 2021", 1740, 3440, 1.25, 320, 0.29, 7.25e-5);
% Nitrocellulose
FUELS(7) = RocketFuel("Nitrocellulose", 1550, 2300, 1.3, 280, 0.7, 10*10^(-(3+6*0.12)));

%%% Motor, Grain, & Nozzle Geometry
params.r_max = 0.127;           % Casing Inner Radius [m]
params.Ae = pi*params.r_max^2;  % Nozzle Exit Area [m^2]
params.V_hardware = 0.2*pi*params.r_max^2;  % Extra Hardware Volume [m^3]
grain.r_in = 0.0435;            % Acceleration Phase Grain Inner Radius [m]
grain.lenCruise = 0.15;         % Cruise Phase Grain Length [m]

%%% Vehicle Body Geometry & Parameters
m0 = 253.8;                     % Dry Mass [kg]
bodyL = 3;                      % Cylinder Equivalent Length [m]
bodyD = 0.254;                  % Cylinder Equivalent Diameter [m]  (10in)
CD = 0.905;                     % Drag Coefficient
Acs = pi*(bodyD/2)^2;           % Cross-Section Area [m^2]
Awet = Acs*2 + pi*bodyD*bodyL;  % Wetted Area [m^2]

%% Optimization Executor
%%% Compute required thrust to offset drag at cruise conditions
cruiseThrust = 0.5 * rho_atm * targetSpeed^2 * Acs * CD;

%%% Iterate over each fuel to test
overshoot = false;
for i = 1:length(FUELS)
    params.fuel = FUELS(i);
    grain.lenAccel = 0.1;

    %%% Compute lift force & coefficient needed during cruise
    cruiseLift = (m0 + (params.fuel.Density*grain.lenCruise*pi*params.r_max^2/2)) * 9.81;
    CL = cruiseLift / (0.5 * rho_atm * targetSpeed^2 * (Awet/2));

    %%% Optimize nozzle geometry constrained by mission cruise requirements
    params.AeAt = Optimize_AeAtCruise(cruiseThrust, params.fuel, params.Ae, params.Ae, Pinf);
    if params.AeAt == 0
        fprintf("\n[FAIL][%s] \t Could not achieve cruise conditions within expansion ratio constraints.", params.fuel.Name)
        continue
    end
    params.At = params.Ae / params.AeAt;
    
    %%% Optimization Loop: Attempt to achieve cruise conditions from t=0
    %%% without overpressurizing the motor.
    while true
        run("BurnbackSim_Annular.m")
        if max(sln_P) > 15e6
            fprintf("\n[FAIL][%s] \t Could not reach Mach 3. Pressure Exceeded 15MPa  @  %.2fm", params.fuel.Name, grain.lenAccel)
            break
        end
        run("FlightSim.m")
        if max(dat_mach) > 3
            fprintf("\n[PASS][%s] \t Mach %.2f  @  %.2fm & ε = %.4f", params.fuel.Name, max(dat_mach), grain.lenAccel, params.AeAt);
            break
        end
        grain.lenAccel = grain.lenAccel + 0.05;
    end
end


clear;
%% Variable Definition
%%% Initial Environment Parameters
H = 21336;
[~, a, Pinf, rho_atm] = atmosisa(H, extended=true);
g0 = 9.81; % Standard gravity (m/s^2)

%%% Target Parameters
targetM = 3;
targetSpeed = targetM * a;
targetPe = 10*Pinf;

%%% Fuel & Exhaust Parameters
params.R_ = 320;            % gas constant
params.T0_ = 3440;          % e.g. chamber temperature (K) == flame temperature?
params.gamma = 1.25;         % ratio of specific heats
params.rho_g = 0.001;       % or some small value if you prefer
params.rho = 1854.55362;    % propellant density

%fuel = RocketFuel("HTPB 2021", 1740, 3440, 1.25, 320, 0.29, 7.25e-5);
%fuel = RocketFuel("HTPB Paper", 1740, 2600, 1.3, 320, 0.12, 5.02*10^(-(3+6*0.12)));
%fuel = RocketFuel("Nitrocellulose", 1550, 2300, 1.3, 280, 0.7, 10*10^(-(3+6*0.12)));
%fuel = RocketFuel("HTPB/AP[65%]", 1854.55362, 3440, 1.3, 320, 0.12, 5.02*10^(-(3+6*0.12)));
fuel = RocketFuel("HTPB/AP[70%]", 1854.55362, 3440, 1.25, 320, 0.098, 6.2*10^(-(3+6*0.098)));
%fuel = RocketFuel("HTPB/AP[75%]/Fe2O3[3%]", 1854.55362, 3440, 1.25, 320, 0.323, 10.31*10^(-(3+6*0.323)));
%fuel = RocketFuel("HTPB/AP[80%]/Fe2O3[3%]", 1854.55362, 3440, 1.25, 320, 0.52, 19.24*10^(-(3+6*0.52)));
%%% Fuel Grain Geometry
params.r_max = 0.127;       % Maximum radius
params.fuel = fuel;
params.V_hardware = 0.2*pi*params.r_max^2; % extra hardware volume, if any
%params.r_max = 0.03335;       % Maximum radius
%params.V_hardware = 0; % extra hardware volume, if any

%%% Nozzle Parameters
params.Ae = pi*params.r_max^2;
params.AeAt = 22.08; %15.9072;
params.At = params.Ae/params.AeAt;
%params.A_t = 0.00693;       % nozzle throat area
%fprintf('\nNozzle Throat Diameter = %.2fcm\n', 100*2*sqrt(params.A_t/pi));

%%% Body Parameters
m0 = 253.8;
bodyL = 3;
bodyD = 0.254;
CD = 0.905;                  % Drag coefficient
Acs = pi*(bodyD/2)^2;        % Body Area: cross-sectional
Awet = Acs*2 + pi*bodyD*bodyL;   % ASSUMPTION: cylindrical shape


%% Sequencer
%%% Annular Grain Analysis
grain.r_in = 0.0435;
grain.lenAccel = 1.235;
grain.lenCruise = 0.15;

%%% 2020 Validation Test
%params.Ae = pi*(0.039/2)^2;
%params.A_t = pi*(0.011/2)^2;
%params.AeAt = params.Ae/params.A_t;
%grain.r_in = 0.015;
%grain.len1 = 0.05;
%grain.lenCruise = 0.00001;
%%%

%run("OptimizeCruise.m")
cruiseLift = (m0 + (params.rho*grain.lenCruise*pi*params.r_max^2/2)) * 9.81;
CL = cruiseLift / (0.5 * rho_atm * targetSpeed^2 * (Awet/2));
cruiseThrust = 0.5 * rho_atm * targetSpeed^2 * Acs * CD;
run("BurnbackSim_Annular.m")

%%%
run("FlightSim.m")


run("results.m")

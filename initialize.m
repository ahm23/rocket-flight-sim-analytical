
%%% Initial Environment Parameters
H = 21336;
[~, a, Pinf, rho_atm] = atmosisa(H, extended=true);
%%% Fuel & Exhaust Parameters
params.R_ = 287;            % gas constant
params.T0_ = 3440;          % e.g. chamber temperature (K) == flame temperature?
params.gamma = 1.3;         % ratio of specific heats
params.rho_g = 0.001;       % or some small value if you prefer
params.rho = 1855;          % propellant density
params.a = 10.19*10^(-(3+6*0.433));        % example burn rate coefficient
params.n = 0.433;           % burn rate exponent
%%% Nozzle Parameters
params.A_t = 0.00493;       % nozzle throat area
params.AeAt = 15.9;
%%% Fuel Grain Geometry
params.len = 1;             % motor grain length, etc.
params.r_max = 0.127;       % Maximum radius
params.V_hardware = 0.2*pi*params.r_max^2; % extra hardware volume, if any

%%% Annular Grain Analysis
grain.r_in = 0.0635;
grain.len1 = 0.2;
grain.len2 = 0.2;
run("BurnbackSim_Annular.m")


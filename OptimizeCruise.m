

cruiseLift = (m0 + (params.rho*grain.len2*pi*params.r_max^2/2)) * 9.81;
CL = cruiseLift / (0.5 * rho_atm * targetSpeed^2 * (Awet/2));

cruiseThrust = 0.5 * rho_atm * targetSpeed^2 * Acs * CD;
%cruiseThrust = 3000;

Ab = params.Ae;

%thrust_eq(Ab, params.A_t, fuel, targetPe, Pinf, params.Ae, cruiseThrust)

At_value = fzero(@(At) thrust_eq(Ab, At, fuel, targetPe, Pinf, params.Ae, cruiseThrust), [Ab/50 Ab]); % Initial guess for At
params.AeAt = params.Ae / At_value;

%fprintf('\nNozzle Throat Diameter = %.2fcm\n', 100*2*sqrt(At_value/pi));
%fprintf('\nExpansion Ratio = %.2fcm\n', params.AeAt);



%% Thrust Equation Function
function T = thrust_eq(Ab, At, fuel, Pe, Pinf, Ae, FT)
    % Calculate P0
    P0 = (fuel.TCoefficient * fuel.Density * fuel.cv * Ab / At)^(1 / (1 - fuel.Stability));
    % Mass flow rate
    mdot = (P0*At*sqrt(fuel.SHR)/sqrt(fuel.GasConstant*fuel.FlameTemp)) * ...
        (2 / (fuel.SHR + 1))^((fuel.SHR + 1) / (2 * (fuel.SHR - 1)));

    ue = sqrt((2*fuel.SHR*fuel.GasConstant*fuel.FlameTemp/(fuel.SHR-1)) * ...
        (1-(Pe/P0)^((fuel.SHR-1)/fuel.SHR)));

    % Thrust equation
    T = FT - (mdot * ue + (Pe - Pinf) * Ae);

    %sqrt((1 - (Pe / P0)^((fuel.SHR - 1) / fuel.SHR)) * ... 2 * fuel.SHR * fuel.GasConstant * fuel.FlameTemp / (fuel.SHR - 1))
    %fprintf('Ab = %.5f, At = %.5f, P0 = %.2f, mdot = %.2f\n', Ab, At, P0, mdot);
end

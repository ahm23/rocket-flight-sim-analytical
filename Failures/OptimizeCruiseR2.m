

cruiseLift = (m0 + (params.rho*grain.len2*pi*params.r_max^2/2)) * 9.81;
CL = cruiseLift / (0.5 * rho_atm * targetSpeed^2 * (Awet/2));

cruiseThrust = 0.5 * rho_atm * targetSpeed^2 * Acs * CD;
%cruiseThrust = 3000;

%% Cruise Phase
syms Me FT
Ae = params.Ae;
Ab = Ae/4:Ae/8:Ae;
AeAt = 5:2:50;

results = cell(1,length(Ab));
for i = 1:4
    results{i} = [];
end

for i = 1:length(AeAt)
    At = Ae / AeAt(i);
    found = false;
    for j = 1:length(Ab)
        % Calculate P0
        P0 = (fuel.TCoefficient * fuel.Density * fuel.cv * Ab(j) / At)^(1 / (1 - fuel.Stability));
        % Mass flow rate
        mdot = (P0*At*sqrt(fuel.SHR)/sqrt(fuel.GasConstant*fuel.FlameTemp)) * ...
            (2 / (fuel.SHR + 1))^((fuel.SHR + 1) / (2 * (fuel.SHR - 1)));
        % Exit Mach Number
        eqn = AeAt(i) == (1/Me) * ((2/(params.gamma+1))*(1+(Me^2)*(params.gamma-1)/2))^((params.gamma+1)/(2*(params.gamma-1)));
        exitMach = vpasolve(eqn, Me, [1 10]);
        if size(exitMach) == 0
            continue
        end
        Pe = P0 / (1 + (exitMach^2)*(params.gamma-1)/2)^(params.gamma/(params.gamma-1));
        % Nozzle exit velocity
        ue = sqrt((2*fuel.SHR*fuel.GasConstant*fuel.FlameTemp/(fuel.SHR-1)) * ...
            (1-(Pe/P0)^((fuel.SHR-1)/fuel.SHR)));
        
        eqn = FT == mdot * ue + Ae * (Pe - Pinf);
        S = vpasolve(eqn,FT,[0 10000]);
        if size(S) > 0
            results{j} = [results{j}, [AeAt(i); double(S); double(Pe); double(P0)]];
            %fprintf('\nFound Solution @ AeAt = %.2f, Ab = %.6f\n', AeAt(i), Ab(j));
        end
    end
end

legendstrings = {};
figure
grid on
ylabel("Thrust [kN]")
xlabel("Nozzle Expansion Ratio Ae/At")
hold on
for k = 1:length(results)
    if size(results{k}) > 0
        legendstrings{end+1} = num2str(2*sqrt(Ab(k)/pi)*100,2) + "cm";
        plot(results{k}(1,:), results{k}(2,:)./10^3, 'LineWidth', 1.5)
    end
end
hold off
lgd = legend(legendstrings);
title(lgd, 'End-Burn Diameter')

figure
grid on
ylabel("Exit Pressure [kPa]")
xlabel("Nozzle Expansion Ratio Ae/At")
hold on
for k = 1:length(results)
    if size(results{k}) > 0
        plot(results{k}(1,:), results{k}(3,:)./10^3, 'LineWidth', 1.5)
    end
end
hold off
lgd = legend(legendstrings);
title(lgd, 'End-Burn Diameter')

figure
grid on
ylabel("Combustion Pressure [kPa]")
xlabel("Nozzle Expansion Ratio Ae/At")
hold on
for k = 1:length(results)
    if size(results{k}) > 0
        plot(results{k}(1,:), results{k}(4,:)./10^3, 'LineWidth', 1.5)
    end
end
hold off
lgd = legend(legendstrings);
title(lgd, 'End-Burn Diameter')

%% Accel Phase
Ab_max = 2*pi*params.r_max*1.25 + pi*params.r_max^2;
Ab_min = 2*pi*params.r_max*0.25 + pi*params.r_max^2;
Ab = Ab_min:(Ab_max-Ab_min)/5:Ab_max;
results = cell(1,length(Ab));
for i = 1:4
    results{i} = [];
end

for i = 1:length(AeAt)
    At = Ae / AeAt(i);
    found = false;
    for j = 1:length(Ab)
        P0 = (fuel.getCV()*fuel.Density*fuel.TCoefficient*Ab(j)/At)^(1/(1-fuel.Stability));
        results{j} = [results{j}, [AeAt(i); P0]];
        %fprintf('\nFound Solution @ AeAt = %.2f, Ab = %.6f\n', AeAt(i), Ab(j));
    end
end

legendstrings = {};
figure
grid on
hold on
for k = 1:length(results)
    if size(results{k}) > 0
        legendstrings{end+1} = num2str((Ab(k) - pi*params.r_max^2)/(2*pi*params.r_max),2) + "m";
        plot(results{k}(1,:), results{k}(2,:)./10^6, 'LineWidth', 1.5)
    end
end
hold off
lgd = legend(legendstrings);
title(lgd, 'Accel-Burn Length')



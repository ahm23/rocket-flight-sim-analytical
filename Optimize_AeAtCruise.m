function [AeAtResult] = Optimize_AeAtCruise(thrust, fuel, Ae, Ab, Pinf)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
syms Me FT
AeAt = 5:1:80;

results = zeros([length(AeAt) 2]);

for i = 1:length(AeAt)
    At = Ae / AeAt(i);
    % Calculate P0
    P0 = (fuel.TCoefficient * fuel.Density * fuel.cv * Ab / At)^(1 / (1 - fuel.Stability));
    % Mass flow rate
    mdot = (P0*At*sqrt(fuel.SHR)/sqrt(fuel.R*fuel.T0)) * ...
        (2 / (fuel.SHR + 1))^((fuel.SHR + 1) / (2 * (fuel.SHR - 1)));
    % Exit Mach Number
    eqn = AeAt(i) == (1/Me) * ((2/(fuel.SHR+1))*(1+(Me^2)*(fuel.SHR-1)/2))^((fuel.SHR+1)/(2*(fuel.SHR-1)));
    exitMach = vpasolve(eqn, Me, [1 10]);
    if size(exitMach) == 0
        continue
    end
    Pe = P0 / (1 + (exitMach^2)*(fuel.SHR-1)/2)^(fuel.SHR/(fuel.SHR-1));
    % Nozzle exit velocity
    ue = sqrt((2*fuel.SHR*fuel.R*fuel.T0/(fuel.SHR-1)) * ...
        (1-(Pe/P0)^((fuel.SHR-1)/fuel.SHR)));
    
    eqn = FT == mdot * ue + Ae * (Pe - Pinf);
    S = vpasolve(eqn,FT,[0 10000]);
    if size(S) > 0
        results(i,:) = [AeAt(i); double(S)];
        if results(i,2) > thrust && results(i-1,2) < thrust
            AeAtResult = results(i-1,1) + (thrust - results(i-1,2))*((results(i,1) - results(i-1,1))/(results(i,2)-results(i-1,2)));
            return
        end
    end
end
AeAtResult = 0;
end
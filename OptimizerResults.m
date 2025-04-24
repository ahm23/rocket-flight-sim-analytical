%% Burnback Simulation Figures
legendstrings = {};
for i = 1:length(results)
   legendstrings{end+1} = results{i}.fuel.Name;
end

%%% Pressure/Time
figure;
hold on
for i = 1:length(results)
   plot(results{i}.burntime, results{i}.P0 ./ 10^6, 'LineWidth', 2); 
end
xlabel('Time [s]', 'FontSize', 14);
ylabel('Pressure [MPa]', 'FontSize', 14);
title('Chamber Pressure vs Time', 'FontSize', 14);
lgd = legend(legendstrings);
title(lgd, 'Fuels')
grid on;
hold off

%%% Thrust/Time
figure;
hold on
ylim([0 140])
for i = 1:length(results)
   plot(results{i}.burntime, results{i}.FT ./ 10^3, 'LineWidth', 2); 
end
xlabel('Time [s]', 'FontSize', 14);
ylabel('Thrust [kN]', 'FontSize', 14);
title('Thrust vs Time', 'FontSize', 14);
lgd = legend(legendstrings);
title(lgd, 'Fuels')
grid on;
hold off

%%% Mass/Time
figure;
hold on
for i = 1:length(results)
   plot(results{i}.burntime, results{i}.mass, 'LineWidth', 2); 
end
xlabel('Time [s]', 'FontSize', 14);
ylabel('Mass [kg]', 'FontSize', 14);
title('Mass vs Time', 'FontSize', 14);
lgd = legend(legendstrings);
title(lgd, 'Fuels')
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

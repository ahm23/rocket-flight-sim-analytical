

%% Forces on the Body
figure;
% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,1);
plot(time, dat_forceY/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Force (Y) [kN]', 'FontSize', 12);
title('Net Force (Y)', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,3);
plot(time, dat_thrustY/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Thrust (Y) [kN]', 'FontSize', 12);
title('Thrust Force on Y-Axis', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,5);
plot(time, dat_liftY/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Lift (Y) [kN]', 'FontSize', 12);
title('Lift Force on Y-Axis', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,7);
plot(time, dat_dragY/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Drag (Y) [kN]', 'FontSize', 12);
title('Drag Force on Y-Axis', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,2);
plot(time, dat_forceX/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Force (X) [kN]', 'FontSize', 12);
title('Net Force (X)', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,4);
plot(time, dat_thrustX/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Thrust (X) [kN]', 'FontSize', 12);
title('Thrust Force on X-Axis', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,6);
plot(time, dat_liftX/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Lift (X) [kN]', 'FontSize', 12);
title('Lift Force on X-Axis', 'FontSize', 12);
grid on;

% --- Bottom subplot: Annular Grain Length ---
subplot(4,2,8);
plot(time, dat_dragX/1000, 'LineWidth', 2);
xlabel('Time [s]', 'FontSize', 12);
ylabel('Drag (X) [kN]', 'FontSize', 12);
title('Drag Force on X-Axis', 'FontSize', 12);
grid on;

%% Flight Profile
figure
hold on
grid on;
plot(time, dat_posY / 1000, Color='blue');
ax = gca; 
ax.FontSize = 12; 
title('Altitude Profile');
xlabel('Time [s]');
ylabel('Altitude [km]');
yyaxis left;
yyaxis right;
plot(time, rad2deg(dat_pitch), 'r--', 'Color', 'red');
%xline(28, 'LineWidth', 2);
ylabel('Angle [deg]');
legend('Altitude', 'Angle', 'Burnout');
hold off

%% DEBUG PLOT: Forces
figure
hold on
ax = gca; 
ax.FontSize = 12; 
plot(time, dat_thrustX / 1000, 'r-.', 'Color', 'red');
plot(time, dat_thrustY / 1000, 'r-.', 'Color', 'blue');
plot(time, dat_lift / 1000, 'r', 'Color', 'green');
plot(time, dat_liftX / 1000, 'r.', 'Color', 'red');
plot(time, dat_liftY / 1000, 'r.', 'Color', 'blue');
plot(time, dat_forceX / 1000, 'r-', 'Color', 'red');
plot(time, dat_forceY / 1000, 'r-', 'Color', 'blue');
plot(time, dat_mass*9.81 / 1000, 'r--', 'Color', 'magenta');
title('Forces on the Rocket');
xlabel('Time [s]');
ylabel('Force [kN]');
yyaxis left;
yyaxis right;
plot(time, dat_posY, 'r', 'Color', 'black');
ylabel('Altitude [km]');
legend('Thrust X', 'Thrust Y', 'Lift', 'Lift X', 'Lift Y', 'Net X', 'Net Y', 'Weight', 'Altitude');
grid on;
hold off

%% Plot for Altitude Profile (with Mach)
figure
hold on
grid on;
plot(time, dat_posY / 1000, Color='blue');
ax = gca; 
ax.FontSize = 12; 
title('Altitude Profile');
xlabel('Time [s]');
ylabel('Altitude [km]');
%ylim([21.2 21.4])
yyaxis left;
yyaxis right;
plot(time, dat_mach, 'r--', 'Color', 'green');
%xline(28, 'LineWidth', 2);
ylabel('Mach');
legend('Altitude', 'Mach', 'Burnout');
hold off

%% Plot for Flight Profile
figure
hold on
grid on;
plot(dat_posX / 1000, dat_posY / 1000, Color='blue');
ax = gca; 
ax.FontSize = 12; 
title('Flight Profile');
xlabel('Distance [km]');
ylabel('Altitude [km]');
hold off


%% Burnback Simulation Figures
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

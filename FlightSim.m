%function [position, velocity, mass] = rocket(angle, payload)
% Author: Ahmed Moussa
launchAoA = 64;
cruiseAoA = 90;
payload = 0;
%fprintf('\nSimulating Rocket\n [PARAMETERS] angle = %.2f, payload = %.2f\n', launchAoA, payload);

% Dimensions
L = 3;
D = 0.254;
As = pi*(D/2)^2;
%As = 0.1;
Aw = As*2 + pi*D*L;   % ASSUMPTION: cylindrical shape

% Constants
G = 6.67430e-11;    % Gravitational constant in m^3/kg/s^2
M_E = 5.972e24;        % Mass of the Earth in kg
R_E = 6.371e6;         % Mean radius of the Earth in meters
g0 = 9.81; % Standard gravity (m/s^2)
m0 = 253.8;

% Convert launch angle to radians for calculation
theta_rad = deg2rad(launchAoA);

%% Initialize datastore arrays
%st = ceil(tSol(end));
%time = [tSol; (st + 1 : st+199)'];
time = tSol;
dat_velX  = zeros(size(time));
dat_velY  = zeros(size(time));
dat_posX  = zeros(size(time));
dat_posY  = zeros(size(time));
%dat_velX(1) = 3*a;
dat_posY(1) = H;

dat_mach  = zeros(size(time));
dat_a     = zeros(size(time));
dat_rho   = zeros(size(time));

dat_drag  = zeros(size(time));
dat_dragX  = zeros(size(time));
dat_dragY  = zeros(size(time));
dat_dragS = zeros(size(time));
dat_dragW = zeros(size(time));
dat_dragB = zeros(size(time));
dat_lift = zeros(size(time));
dat_liftY = zeros(size(time));
dat_liftX = zeros(size(time));

dat_thrustY = zeros(size(time));
dat_thrustX = zeros(size(time));
dat_forceY = zeros(size(time));
dat_forceX = zeros(size(time));

dat_mass = sln_m + m0;
dat_angle = zeros(size(time));
dat_pitch = zeros(size(time));
dat_angle(1) = theta_rad;

for i = 1:length(time)
    % Recompute air properties
    [~, a, ~, rho] = atmosisa(dat_posY(i), extended=true);
    dat_a(i) = a;
    dat_rho(i) = rho;
    
    % Current velocity and drag calculation
    v = sqrt(dat_velX(i)^2 + dat_velY(i)^2);
    dat_mach(i) = v/a;
    
    if i < length(tSol1)
        progress = i / length(tSol1);
        smooth_progress = 3*progress^2 - 2*progress^3;  % smoothstep interpolation
        dat_pitch(i) = deg2rad( launchAoA + (cruiseAoA - launchAoA)*smooth_progress );
    else
        dat_pitch(i) = deg2rad(cruiseAoA);
    end

    if (v > 0)
        [dat_drag(i), dat_dragS(i), dat_dragW(i), dat_dragB(i)] = compute_drag(v, rho, Aw, As);
        dat_lift(i) = compute_lift(v, rho, Aw, CL);
        %dat_dragX(i) = dat_drag(i) * (dat_velX(i) / v);
        %dat_dragY(i) = dat_drag(i) * (dat_velY(i) / v);
        dat_dragX(i) = dat_drag(i) * -sin(dat_pitch(i));
        dat_dragY(i) = dat_drag(i) * -cos(dat_pitch(i));
        %liftX = dat_lift(i) * -sin(pi/2-dat_angle(i));
        %liftY = dat_lift(i) * cos(pi/2-dat_angle(i));
        liftX = dat_lift(i) * -sin(pi/2 - dat_pitch(i));
        liftY = dat_lift(i) * cos(pi/2 - dat_pitch(i));
    else
        dragX = 0;
        dragY = 0;
        liftX = 0;
        liftY = 0;
    end

    if (i > length(dat_mass))
        dat_mass(i) = m0;
        thrust(i) = 0;
    end

    if i + 1 > size(time)
        break;
    end

    dt = time(i+1) - time(i);

    % Decompose thrust into horizontal and vertical components
    thrustX = thrust(i) * sin(dat_pitch(i));
    thrustY = thrust(i) * cos(dat_pitch(i));

    % Net force components
    Fx = thrustX + dat_dragX(i);
    Fy = thrustY + liftY - dat_dragY(i) - dat_mass(i) * 9.81;
    %Fy = thrustY + liftY - dragY - dat_mass(i) * G * M_E / (R_E + dat_posY(i))^2;
    
    %if dat_mach(i) > 3 && i > length(tSol1)
    %    finForce = -Fy;
    %    Fy = 0;
    %else 
    %    finForce = 0;
    %end

    % Acceleration components
    ax = Fx / dat_mass(i);
    ay = Fy / dat_mass(i);
    
    %%% Debug Data Cache Update
    dat_thrustX(i) = thrustX;
    dat_thrustY(i) = thrustY;
    dat_liftY(i) = liftY;
    dat_liftX(i) = liftX;
    dat_forceY(i) = Fy;
    dat_forceX(i) = Fx;
    %%% ------------------
    
    % Update velocity and position
    dat_velX(i+1) = compute_diff(dat_velX(i), ax, dt);
    dat_velY(i+1) = compute_diff(dat_velY(i), ay, dt);
    dat_posX(i+1) = compute_diff(dat_posX(i), dat_velX(i), dt);
    dat_posY(i+1) = compute_diff(dat_posY(i), dat_velY(i), dt);
    if dat_posY(i+1) < 0
        dat_velX(i+1) = 0;
        dat_velY(i+1) = 0;
        dat_posY(i+1) = 0;
    end
    if dat_mach(i) > 3 && i > length(tSol1)
        dat_velY(i+1) = 0;
    end
    if dat_posY(i+1) > 0
        dat_angle(i+1) = atan2(dat_velX(i+1),dat_velY(i+1));
    else
        dat_angle(i+1) = dat_angle(i);
        %break;
    end
    %fprintf('T: %.3fs - %.3fs | X Accel %.4f | Y Accel %.4f | Vel %.4f | Mach %.4f | Drag %.4f | X Drag %.4f | Y Drag %.4f |\n', time(i), time(i+1), ax, ay, v, dat_mach(i), dat_drag(i), dragX, dragY);
end

%{
figure
subplot(2,1,1)
plot(dat_posY(1:ind)./1000, dat_a(1:ind))
title('Speed of Sound vs. Altitude');
xlabel('Altitude [km]');
ylabel('Speed [m/s]');

subplot(2,1,2)
plot(dat_posY(1:ind)./1000, dat_rho(1:ind))
title('Atmospheric Density vs. Altitude');
xlabel('Altitude [km]');
ylabel('Air Density [kg/m^3]');
%}

%figure
%plot(dat_posX, dat_posY)


%end
function dXdt = RocketSystem_Cylinder(t, X, params)
    % X(1) = P(t) (pressure)
    % X(2) = r_in(t) (inner radius)
    % X(3) = len(t) (grain length)
    
    % Unpack the states:
    P    = X(1);
    len  = X(2);
    
    % Unpack parameters (params is a struct you create):
    R_      = params.fuel.R;
    T0_     = params.fuel.T0;
    rho     = params.fuel.Density;
    rho_g   = params.rho_g;
    a       = params.fuel.TCoefficient;
    n       = params.fuel.Stability;
    A_t     = params.At;
    gamma   = params.fuel.SHR;      % shr in your code
    %len     = params.len;        % length of the grain
    V_hw    = params.V_hardware; % the "dead volume" or hardware volume, if any
    
    % 1) Compute geometry:
    Ab = params.Ae;  % for an annular shape burning radially in
    % Example: volume grows as r_in^2 (internal radius). 
    % You might define it as below, but adapt to your geometry:
    %Vg = V_hw + pi*(params.r_max^2)*len;
    Vg = V_hw;
    
    % 2) ODE for dr_in/dt = a * P^n
    dlen_dt = -a * P^n;
    
    % 3) ODE for dP/dt
    % -- compute mass addition piece:
    %    (R_*T0_/Vg) * (rho - rho_g) * a * Ab * P^n
    term_in = (R_ * T0_ / Vg) * (rho - rho_g) * a * Ab * P^n;
    
    % -- compute mass out (nozzle) piece:
    %    (At * sqrt(gamma*R_*T0_)/Vg) * (2/(gamma+1))^((gamma+1)/(2*(gamma-1))) * P
    throatFactor = ( A_t * sqrt(gamma * R_ * T0_) / Vg ) ...
                   * (2/(gamma+1))^((gamma+1)/(2*(gamma-1)));
    term_out = throatFactor * P;
    
    dPdt = term_in - term_out;
    
    % Return derivatives as a column vector:
    dXdt = [ dPdt; dlen_dt ];
end
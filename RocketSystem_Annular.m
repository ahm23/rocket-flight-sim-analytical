function dXdt = RocketSystem_Annular(t, X, params, base)
    % X(1) = P(t) (pressure)
    % X(2) = r_in(t) (inner radius)
    % X(3) = len(t) (grain length)
    
    % Unpack the states:
    P    = X(1);
    r_in = X(2);
    len = X(3);
    
    % Unpack parameters (params is a struct you create):
    R_      = params.R_;
    T0_     = params.T0_;
    rho     = params.rho;
    rho_g   = params.rho_g;
    a       = params.a;
    n       = params.n;
    A_t     = params.A_t;
    gamma   = params.gamma;      % shr in your code
    %len     = params.len;        % length of the grain
    V_hw    = params.V_hardware; % the "dead volume" or hardware volume, if any
    
    % 1) Compute geometry:
    Ab = 2 * pi * r_in * len;  % for an annular shape burning radially in
    % Example: volume grows as r_in^2 (internal radius). 
    % You might define it as below, but adapt to your geometry:
    Vg = V_hw + pi*(r_in^2)*len;
    
    % 2) ODE for dr_in/dt = a * P^n
    drin_dt = a * P^n;

    if base
        dlen_dt = 0;
    else
        dlen_dt = -a * P^n;
    end
    
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
    dXdt = [ dPdt; drin_dt; dlen_dt ];
end
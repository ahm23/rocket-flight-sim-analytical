function [lift] = compute_lift(speed, density, Aw, CL)
    % Author: Ahmed Moussa
    %CL = 0.0265523669311733;
    %CL = 0.0516591331206218;
    %CL = 0.0713800521886641;

    lift = 0.5 * density * speed^2 * (Aw/2) * CL;
end
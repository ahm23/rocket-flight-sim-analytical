function [value, isterminal, direction] = EVENT_ACCELPHASECOMPLETE(t, X, r_max)
    % X(1) = P(t)
    % X(2) = r_in(t)
    
    r_in   = X(2);            % current inner radius
    
    % "value" is the quantity we watch for zero-crossing
    value = r_in - r_max;     % we want to stop when r_in == r_max
    
    % "isterminal=1" means stop the integration when value = 0
    isterminal = 1;
    
    % "direction=+1" means we only detect zero-crossing as value goes from negative to positive
    % If you're not sure, you can set direction = 0 to catch any crossing
    direction = 0;
end
function [drag, dragS, dragW, dragB] = compute_drag(speed, density, Aw, As)
    % Author: Ahmed Moussa
    CDs = 0.05;
    CDw = 0;
    CDb = 0.905;

    if speed == 0
        dragS = 0;
        dragW = 0;
        dragB = 0;
    else
        dragS = 0.5 * density * speed^2 * Aw * CDs;
        dragW = 0.5 * density * speed^2 * As * CDw;
        dragB = 0.5 * density * speed^2 * As * CDb;
    end
    dragS = 0;
    dragW = 0;
    %dragB = 0;
    drag = dragS + dragW + dragB;
end
classdef ResultBundle
   properties
    fuel
    P0
    mass
    FT
    burntime
   end
   methods
       function obj = ResultBundle(fuel, sln_t, sln_P, sln_FT, sln_m)
            obj.fuel = fuel;
            obj.P0 = sln_P;
            obj.FT = sln_FT;
            obj.mass = sln_m;
            obj.burntime = sln_t;
            
       end
   end
end
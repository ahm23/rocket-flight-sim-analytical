classdef RocketFuel
   properties
      Name
      Density
      T0
      %BurnRate
      SHR
      R
      Stability
      TCoefficient
      cv
   end
   methods
       function obj = RocketFuel(name, density, flameTemp, shr, gasConstant, stability, coef)
            obj.Name = name;
            obj.Density = density;
            obj.T0 = flameTemp;
            %obj.BurnRate = burnRate/1000;
            obj.SHR = shr;
            obj.R = gasConstant;
            obj.Stability = stability;
            obj.TCoefficient = coef;
            obj.cv = sqrt((obj.R*obj.T0/obj.SHR)*((obj.SHR+1)/2)^((obj.SHR+1)/(obj.SHR-1)));
        end
        function cv = getCV(obj)
            cv = sqrt((obj.R*obj.T0/obj.SHR)*((obj.SHR+1)/2)^((obj.SHR+1)/(obj.SHR-1)));
        end
   end
end
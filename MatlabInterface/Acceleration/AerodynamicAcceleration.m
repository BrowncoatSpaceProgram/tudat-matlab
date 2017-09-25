classdef AerodynamicAcceleration < Acceleration
    methods
        function obj = AerodynamicAcceleration()
            obj@Acceleration(Accelerations.aerodynamic);
        end
        
    end
    
end

classdef RadiationPressureAcceleration < Acceleration
    methods
        function obj = RadiationPressureAcceleration()
            obj@Acceleration(Accelerations.cannonBallRadiationPressure);
        end
        
    end
    
end

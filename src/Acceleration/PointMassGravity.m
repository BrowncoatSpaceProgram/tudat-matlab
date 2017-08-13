classdef PointMassGravity < Acceleration
    methods
        function obj = PointMassGravity()
            obj@Acceleration(Accelerations.pointMassGravity);
        end
        
    end
    
end

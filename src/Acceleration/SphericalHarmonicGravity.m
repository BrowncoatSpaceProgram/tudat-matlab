classdef SphericalHarmonicGravity < Acceleration
    properties
        maximumDegree
        maximumOrder
    end
    
    methods
        function obj = SphericalHarmonicGravity(maximumDegree,maximumOrder)
            obj@Acceleration(Accelerations.sphericalHarmonicGravity);
            obj.maximumDegree = maximumDegree;
            obj.maximumOrder = maximumOrder;
        end
        
    end
    
end

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

        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Acceleration(obj);
            mp = horzcat(mp,{'maximumDegree','maximumOrder'});
        end
        
    end
    
end

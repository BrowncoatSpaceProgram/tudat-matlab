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
        
        function s = struct(obj)
            s = struct@Acceleration(obj);
            s = json.update(s,obj,'maximumDegree');
            s = json.update(s,obj,'maximumOrder');
        end

    end
    
end

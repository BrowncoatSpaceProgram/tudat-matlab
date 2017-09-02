classdef ThrustDirection < jsonable
    properties
        type
        relativeBody
        colinearWithVelocity
        towardsRelativeBody
    end
    
    methods
        function obj = ThrustDirection(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'ThrustDirections')
                value = ThrustDirections(value);
            end
            obj.type = value;
        end
        
        function bodyName = get.relativeBody(obj)
            if isa(obj.relativeBody,'Body')
                bodyName = obj.relativeBody.name;
            else
                bodyName = obj.relativeBody;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type','relativeBody'};
            if obj.type == ThrustDirections.colinearWithStateSegment
                mp = horzcat(mp,'colinearWithVelocity','towardsRelativeBody');
            end
        end
        
    end
    
end

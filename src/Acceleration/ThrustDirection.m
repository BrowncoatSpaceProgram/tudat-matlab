classdef ThrustDirection < handle
    properties
        type
        relativeBody
        colinearWithVelocity
        towardsRelativeBody
    end
    
    methods
        function obj = ThrustDirection(type)
            obj.type = type;
        end
        
        function set.type(obj,value)
            if ~isa(value,'ThrustDirections')
                value = ThrustDirections(value);
            end
            obj.type = char(value);
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'type');
            s = json.update(s,obj,'relativeBody');
            s = json.update(s,obj,'colinearWithVelocity',obj.type == ThrustDirections.colinearWithStateSegment);
            s = json.update(s,obj,'towardsRelativeBody',obj.type == ThrustDirections.colinearWithStateSegment);
        end
        
    end
    
end

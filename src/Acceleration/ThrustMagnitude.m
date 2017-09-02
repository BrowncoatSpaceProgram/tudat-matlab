classdef ThrustMagnitude < jsonable
    properties
        type
        originID
    end
    
    methods
        function obj = ThrustMagnitude(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'ThrustMagnitudes')
                value = ThrustMagnitudes(value);
            end
            obj.type = value;
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type','relativeBody'};
            if obj.type == ThrustMagnitudes.fromEngineProperties
                mp{end+1} = 'originID';
            end
        end
        
    end
    
end

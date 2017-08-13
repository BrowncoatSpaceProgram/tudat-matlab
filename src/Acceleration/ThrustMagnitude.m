classdef ThrustMagnitude
    properties
        type
        originID
    end
    
    methods
        function obj = ThrustMagnitude(type)
            obj.type = type;
        end
        
        function obj = set.type(obj,value)
            if ~isa(value,'ThrustMagnitudes')
                value = ThrustMagnitudes(value);
            end
            obj.type = char(value);
        end

        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'type');
            s = json.update(s,obj,'originID',obj.type == ThrustMagnitudes.fromEngineProperties);
        end
        
    end
    
end

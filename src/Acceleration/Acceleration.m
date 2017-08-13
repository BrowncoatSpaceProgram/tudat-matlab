classdef Acceleration
    properties
        type
    end
    
    methods
        function obj = Acceleration(type)
            obj.type = type;
        end
        
        function obj = set.type(obj,value)
            if ~isa(value,'Accelerations')
                value = Accelerations(value);
            end
            obj.type = char(value);
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'type');
        end
        
    end
    
end

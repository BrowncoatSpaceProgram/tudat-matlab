classdef MassRateModel < handle
    properties
        type
    end
    
    methods
        function obj = MassRateModel(type)
            obj.type = type;
        end
        
        function set.type(obj,value)
            if ~isa(value,'MassRateModels')
                value = MassRateModels(value);
            end
            obj.type = char(value);
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'type');
        end
        
    end
    
end

classdef Atmosphere < jsonable
    properties
        type
    end
    
    methods
        function obj = Atmosphere(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'AtmosphereModels')
                value = AtmosphereModels(value);
            end
            obj.type = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type'};
        end
        
    end
    
end

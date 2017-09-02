classdef MassRateModel < jsonable
    properties
        type
    end
    
    methods
        function obj = MassRateModel(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'MassRateModels')
                value = MassRateModels(value);
            end
            obj.type = value;
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type'};
        end
        
    end
    
end

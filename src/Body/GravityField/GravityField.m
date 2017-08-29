classdef GravityField < jsonable
    properties
        type
    end
    
    methods
        function obj = GravityField(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'GravityFields')
                value = GravityFields(value);
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

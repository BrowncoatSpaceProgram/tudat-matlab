classdef Acceleration < jsonable
    properties
        type
    end
    
    methods
        function obj = Acceleration(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'Accelerations')
                value = Accelerations(value);
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

classdef Torque < jsonable
    properties
        type
    end
    
    methods
        function obj = Torque(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'Torques')
                value = Torques(value);
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

classdef RotationModel < jsonable
    properties
        type
        originalFrame
        targetFrame
    end
    
    methods
        function obj = RotationModel(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'RotationModels')
                value = RotationModels(value);
            end
            obj.type = value;
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type','originalFrame','targetFrame'};
        end
        
    end
    
end

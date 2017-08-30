classdef GravityFieldVariation < jsonable
    properties
        bodyDeformationType
    end
    
    methods
        function obj = GravityFieldVariation(bodyDeformationType)
            if nargin >= 1
                obj.bodyDeformationType = bodyDeformationType;
            end
        end
        
        function set.bodyDeformationType(obj,value)
            if ~isa(value,'BodyDeformations')
                value = BodyDeformations(value);
            end
            obj.bodyDeformationType = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type'};
        end
        
    end
    
end

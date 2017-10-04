classdef SphericalShapeModel < ShapeModel
    properties
        radius
    end
    
    methods
        function obj = SphericalShapeModel(radius)
            obj@ShapeModel(ShapeModels.spherical);
            if nargin >= 1
                obj.radius = radius;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ShapeModel(obj);
            mp = horzcat(mp,{'radius'});
        end
        
    end
    
end

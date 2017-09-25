classdef SphericalShapeModel < ShapeModel
    properties
        radius
    end
    
    methods
        function obj = SphericalShapeModel()
            obj@ShapeModel(ShapeModels.spherical);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ShapeModel(obj);
            mp = horzcat(mp,{'radius'});
        end
        
    end
    
end

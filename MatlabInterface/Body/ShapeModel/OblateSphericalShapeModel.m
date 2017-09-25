classdef OblateSphericalShapeModel < ShapeModel
    properties
        equatorialRadius
        flattening
    end
    
    methods
        function obj = OblateSphericalShapeModel()
            obj@ShapeModel(ShapeModels.oblateSpheroid);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ShapeModel(obj);
            mp = horzcat(mp,{'equatorialRadius','flattening'});
        end
        
    end
    
end

classdef OblateSphericalShapeModel < ShapeModel
    properties
        equatorialRadius
        flattening
    end
    
    methods
        function obj = OblateSphericalShapeModel(equatorialRadius,flattening)
            obj@ShapeModel(ShapeModels.oblateSpheroid);
            if nargin >= 1
                obj.equatorialRadius = equatorialRadius;
                if nargin >= 2
                    obj.flattening = flattening;
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ShapeModel(obj);
            mp = horzcat(mp,{'equatorialRadius','flattening'});
        end
        
    end
    
end

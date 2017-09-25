classdef SphericalSpiceShapeModel < ShapeModel
    properties
        
    end
    
    methods
        function obj = SphericalSpiceShapeModel()
            obj@ShapeModel(ShapeModels.sphericalSpice);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ShapeModel(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end

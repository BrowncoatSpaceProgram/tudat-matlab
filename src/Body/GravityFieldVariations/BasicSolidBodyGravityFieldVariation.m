classdef BasicSolidBodyGravityFieldVariation < GravityFieldVariation
    properties
        deformingBodies
        loveNumbers
        referenceRadius
        modelInterpolation
    end
    
    methods
        function obj = BasicSolidBodyGravityFieldVariation()
            obj@GravityFieldVariation(BodyDeformations.basicSolidBody);
            obj.modelInterpolation = ModelInterpolation();
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@GravityFieldVariation(obj);
            mp = horzcat(mp,{'deformingBodies','loveNumbers','referenceRadius'});
        end
        
    end
    
end

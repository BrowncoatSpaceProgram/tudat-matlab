classdef BasicSolidBodyGravityFieldVariation < GravityFieldVariation
    properties
        deformingBodies
        loveNumbers
        referenceRadius
        modelInterpolation = ModelInterpolation
    end
    
    methods
        function obj = BasicSolidBodyGravityFieldVariation()
            obj@GravityFieldVariation(BodyDeformations.basicSolidBody);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@GravityFieldVariation(obj);
            mp = horzcat(mp,{'deformingBodies','loveNumbers','referenceRadius'});
        end
        
    end
    
end

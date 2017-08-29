classdef CannonBallRadiationPressure < RadiationPressure
    properties
        referenceArea
        radiationPressureCoefficient
        occultingBodies
    end
    
    methods
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@RadiationPressure(obj);
            mp = horzcat(mp,{'radiationPressureCoefficient'});
        end
        
    end
    
end

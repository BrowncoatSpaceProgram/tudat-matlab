classdef RelativisticCorrectionAcceleration < Acceleration
    properties
        calculateSchwarzschildCorrection
        calculateLenseThirringCorrection
        calculateDeSitterCorrection
        primaryBody
        centralBodyAngularMomentum
    end
    
    methods
        function obj = RelativisticCorrectionAcceleration()
            obj@Acceleration(Accelerations.relativisticCorrection);
        end
        
        function bodyName = get.primaryBody(obj)
            if isa(obj.primaryBody,'Body')
                bodyName = obj.primaryBody.name;
            else
                bodyName = obj.primaryBody;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Acceleration(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end

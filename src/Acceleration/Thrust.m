classdef Thrust < Acceleration
    properties
        direction = ThrustDirection
        magnitude = ThrustMagnitude
        dataInterpolation
        specificImpulse
        frame
        centralBody
    end
    
    methods
        function obj = Thrust()
            obj@Acceleration(Accelerations.thrust);
        end
        
        function p = getProperties(obj)
            p = getProperties@Acceleration(obj);
            if ~isempty(obj.dataInterpolation)
                p = horzcat(p,{'dataInterpolation','specificImpulse','frame','centralBody'});
            else
                p = horzcat(p,{'direction','magnitude'});
            end
        end

        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Acceleration(obj);
            if ~isempty(obj.dataInterpolation)
                mp =  horzcat(mp,{'dataInterpolation','specificImpulse','frame'});
            else
                mp =  horzcat(mp,{'direction','magnitude'});
            end
        end
        
    end
    
end

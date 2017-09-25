classdef Thrust < Acceleration
    properties
        direction
        magnitude
        dataInterpolation
        specificImpulse
        frame
        centralBody
    end
    
    methods
        function obj = Thrust()
            obj@Acceleration(Accelerations.thrust);
            obj.direction = ThrustDirection();
            obj.magnitude = ThrustMagnitude();
            obj.dataInterpolation = DataInterpolation();
        end
        
        function bodyName = get.centralBody(obj)
            if isa(obj.centralBody,'Body')
                bodyName = obj.centralBody.name;
            else
                bodyName = obj.centralBody;
            end
        end
        
       function set.frame(obj,value)
            if ~isa(value,'ThrustFrames')
                value = ThrustFrames(value);
            end
            obj.frame = value;
       end
       
    end
    
    methods (Hidden)
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

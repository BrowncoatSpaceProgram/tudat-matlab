classdef ConstantThrustMagnitude < ThrustMagnitude
    properties
        constantMagnitude
        specificImpulse
        bodyFixedDirection
    end
    
    methods
        function obj = ConstantThrustMagnitude(constantMagnitude,specificImpulse)
            obj@ThrustMagnitude(ThrustMagnitudes.constant);
            obj.constantMagnitude = constantMagnitude;
            obj.specificImpulse = specificImpulse;
        end

    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ThrustMagnitude(obj);
            mp = horzcat(mp,{'constantMagnitude','specificImpulse'});
        end
        
    end
    
end

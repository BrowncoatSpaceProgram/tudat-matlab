classdef ConstantThrustMagnitude < ThrustMagnitude
    properties
        constantMagnitude
        specificImpulse
        bodyFixedDirection
    end
    
    methods
        function obj = ConstantThrustMagnitude(constantMagnitude,specificImpulse)
            obj@ThrustMagnitude(ThrustMagnitudes.constant);
            if nargin >= 1
                obj.constantMagnitude = constantMagnitude;
                if nargin >= 2
                    obj.specificImpulse = specificImpulse;
                end
            end
        end

    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ThrustMagnitude(obj);
            mp = horzcat(mp,{'constantMagnitude','specificImpulse'});
        end
        
    end
    
end

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

        function s = struct(obj)
            s = struct@ThrustMagnitude(obj);
            s = json.update(s,obj,'constantMagnitude');
            s = json.update(s,obj,'specificImpulse');
            s = json.update(s,obj,'bodyFixedDirection',false);
        end
        
    end
    
end

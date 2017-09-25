classdef FromBodyThrustMagnitude < ThrustMagnitude
    properties
        useAllEngines
    end
    
    methods
        function obj = FromBodyThrustMagnitude()
            obj@ThrustMagnitude(ThrustMagnitudes.fromEngineProperties);
        end

    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@ThrustMagnitude(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end

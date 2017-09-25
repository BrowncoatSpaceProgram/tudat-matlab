classdef EmpiricalAcceleration < Acceleration
    properties
        constantAcceleration
        sineAcceleration
        cosineAcceleration
    end
    
    methods
        function obj = EmpiricalAcceleration()
            obj@Acceleration(Accelerations.empirical);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Acceleration(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end

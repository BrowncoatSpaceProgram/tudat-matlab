classdef Sun < Body
    methods
        function obj = Sun()
            obj@Body('Sun',true);
        end
    end
    
    properties (Constant, Transient)
        averageRadius = 6.957e8
        gravitationalParameter = 1.327124400189e20
    end
    
end

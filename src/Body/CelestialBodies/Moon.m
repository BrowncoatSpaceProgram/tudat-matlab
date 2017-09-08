classdef Moon < Body
    methods
        function obj = Moon()
            obj@Body('Moon',true);
        end
    end
    
    properties (Constant, Transient)
        averageRadius = 1.737e6
        gravitationalParameter = 4.90486959e12
    end
    
end

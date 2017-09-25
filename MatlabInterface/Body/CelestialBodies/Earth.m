classdef Earth < Body
    methods
        function obj = Earth()
            obj@Body('Earth',true);
        end
    end
    
    properties (Constant, Transient)
        averageRadius = 6.371e6
        gravitationalParameter = 3.986004418e14
    end
    
end

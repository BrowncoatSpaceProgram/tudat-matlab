classdef Moon < Body
    methods
        function obj = Moon()
            obj@Body('Moon',true);
        end
    end
end

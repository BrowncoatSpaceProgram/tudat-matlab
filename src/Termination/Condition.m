classdef Condition < handle
    properties
        variable
        lowerLimit
        upperLimit
    end
    
    methods
        function termination = and(obj1,obj2)
            termination = Termination(true,obj1,obj2);
        end
        
        function termination = or(obj1,obj2)
            termination = Termination(false,obj1,obj2);
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'variable');
            s = json.update(s,obj,'lowerLimit',isempty(obj.upperLimit));
            s = json.update(s,obj,'upperLimit',isempty(obj.lowerLimit));
        end
        
    end
    
end

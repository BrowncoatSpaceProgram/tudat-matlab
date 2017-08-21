classdef Condition < jsonable
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
        
        function mp = getMandatoryProperties(obj)
            mp = {'variable'};
            if isempty(obj.upperLimit)
                mp{end+1} = 'lowerLimit';
            else
                mp{end+1} = 'upperLimit';
            end
        end
        
    end
    
end

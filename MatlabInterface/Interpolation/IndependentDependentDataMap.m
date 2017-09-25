classdef IndependentDependentDataMap < DataMap
    properties
        independentVariableValues
        dependentVariableValues
    end
    
    methods
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'independentVariableValues','dependentVariableValues'};
        end
        
    end
    
end

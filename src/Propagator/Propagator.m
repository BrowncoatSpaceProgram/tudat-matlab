classdef Propagator < jsonable
    properties
        integratedStateType
        bodiesToPropagate
        initialStates
    end
    
    methods
        function obj = Propagator(integratedStateType)
            obj.integratedStateType = integratedStateType;
        end
        
        function set.integratedStateType(obj,value)
            if ~isa(value,'IntegratedStates')
                value = IntegratedStates(value);
            end
            obj.integratedStateType = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'integratedStateType','bodiesToPropagate'};
        end
        
    end
    
end

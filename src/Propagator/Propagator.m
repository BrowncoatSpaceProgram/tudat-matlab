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
            obj.integratedStateType = value;
        end
        
        function bodyNames = get.bodiesToPropagate(obj)
            if isempty(obj.bodiesToPropagate)
                bodyNames = obj.bodiesToPropagate;
            else
                if iscell(obj.bodiesToPropagate)
                    bodyNames = obj.bodiesToPropagate;
                else
                    bodyNames = { obj.bodiesToPropagate };
                end
                for i = 1:length(bodyNames)
                    if isa(bodyNames{i},'Body')
                        bodyNames{i} = bodyNames{i}.name;
                    end
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'integratedStateType','bodiesToPropagate'};
        end
        
    end
    
end

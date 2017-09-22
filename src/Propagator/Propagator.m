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
            bodyNames = cell(size(obj.bodiesToPropagate));
            for i = 1:length(obj.bodiesToPropagate)
                if isa(obj.bodiesToPropagate{i},'Body')
                    bodyNames{i} = obj.bodiesToPropagate{i}.name;
                else
                    bodyNames{i} = obj.bodiesToPropagate{i};
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

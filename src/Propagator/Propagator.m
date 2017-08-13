classdef Propagator
    properties
        integratedStateType
        initialStates
        termination
        computeVariables
        printInterval
    end
    properties (Dependent)
        initialState
    end
    
    methods
        function obj = Propagator(integratedStateType)
            obj.integratedStateType = integratedStateType;
        end
        
        function obj = set.integratedStateType(obj,value)
            if ~isa(value,'IntegratedStates')
                value = IntegratedStates(value);
            end
            obj.integratedStateType = char(value);
        end
        
        function value = get.initialState(obj)
            value = obj.initialStates;
        end
        
        function obj = set.initialState(obj,value)
            obj.initialStates = value;
        end
        
        function obj = set.computeVariables(obj,variables)
            obj.computeVariables = {};
            if ~iscell(variables)
                variables = { variables };
            end
            for i = 1:length(variables)
                obj.computeVariables{i} = Variable(variables{i});
            end
        end
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'integratedStateType');
            s = json.update(s,obj,'initialStates',false);
            s = json.update(s,obj,'termination',false);
            s = json.update(s,obj,'computeVariables',false);
            s = json.update(s,obj,'printInterval',false);
        end

    end
    
end

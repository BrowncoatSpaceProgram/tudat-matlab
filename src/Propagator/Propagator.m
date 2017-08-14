classdef Propagator < handle
    properties
        integratedStateType
        bodiesToPropagate
        initialStates
        termination
        computeVariables
        printInterval
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
        
        function set.computeVariables(obj,variables)
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
            s = json.update(s,obj,'bodiesToPropagate',obj.integratedStateType ~= IntegratedStates.hybrid);
            s = json.update(s,obj,'initialStates',false);
            s = json.update(s,obj,'termination',false);
            s = json.update(s,obj,'computeVariables',false);
            s = json.update(s,obj,'printInterval',false);
        end
        
    end
    
end

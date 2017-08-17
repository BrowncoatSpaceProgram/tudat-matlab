classdef Propagator < handle
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
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'integratedStateType');
            s = json.update(s,obj,'bodiesToPropagate');
            s = json.update(s,obj,'initialStates',false);
        end
        
    end
    
end

classdef MassPropagator < Propagator
    properties
        bodiesToPropagate
        massRates
    end
    properties (Dependent)
        bodyToPropagate
    end
    
    methods
        function obj = MassPropagator(translationalPropagatorType)
            obj@Propagator(IntegratedStates.mass);
            if nargin > 0
                obj.type = translationalPropagatorType;
            end
        end
                
        function value = get.bodyToPropagate(obj)
            value = obj.bodiesToPropagate{1};
        end
        
        function obj = set.bodyToPropagate(obj,value)
            obj.bodiesToPropagate = { value };
        end
        
        function s = struct(obj)
            s = struct@Propagator(obj);
            s = json.update(s,obj,'bodiesToPropagate');
            s = json.update(s,obj,'massRates');
        end

    end
    
end

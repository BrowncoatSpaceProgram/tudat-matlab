classdef TranslationalPropagator < Propagator
    properties
        type
        centralBodies
        bodiesToPropagate
        accelerations
    end
    properties (Dependent)
        centralBody
        bodyToPropagate
    end
    
    methods
        function obj = TranslationalPropagator(translationalPropagatorType)
            obj@Propagator(IntegratedStates.translational);
            if nargin > 0
                obj.type = translationalPropagatorType;
            end
        end
        
        function obj = set.type(obj,value)
            if ~isa(value,'TranslationalPropagators')
                value = TranslationalPropagators(value);
            end
            obj.type = char(value);
        end
        
        function value = get.centralBody(obj)
            value = obj.centralBodies{1};
        end
        
        function obj = set.centralBody(obj,value)
            obj.centralBodies = { value };
        end
        
        function value = get.bodyToPropagate(obj)
            value = obj.bodiesToPropagate{1};
        end
        
        function obj = set.bodyToPropagate(obj,value)
            obj.bodiesToPropagate = { value };
        end
        
        function s = struct(obj)
            s = struct@Propagator(obj);
            s = json.update(s,obj,'type',false);
            s = json.update(s,obj,'centralBodies');
            s = json.update(s,obj,'bodiesToPropagate');
            s = json.update(s,obj,'accelerations');
        end

    end
    
end

classdef TranslationalPropagator < Propagator
    properties
        type
        centralBodies
        accelerations
    end
    
    methods
        function obj = TranslationalPropagator(translationalPropagatorType)
            obj@Propagator(IntegratedStates.translational);
            if nargin > 0
                obj.type = translationalPropagatorType;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'TranslationalPropagators')
                value = TranslationalPropagators(value);
            end
            obj.type = char(value);
        end
        
        function s = struct(obj)
            s = struct@Propagator(obj);
            s = json.update(s,obj,'type',false);
            s = json.update(s,obj,'centralBodies');
            s = json.update(s,obj,'accelerations');
        end

    end
    
end

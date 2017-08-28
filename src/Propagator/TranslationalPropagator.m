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
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Propagator(obj);
            mp = horzcat(mp,{'centralBodies','accelerations'});
        end
        
    end
    
end

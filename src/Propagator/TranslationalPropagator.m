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
            obj.type = value;
        end
        
        function bodyNames = get.centralBodies(obj)
            if iscell(obj.centralBodies)
                bodyNames = obj.centralBodies;
            else
                bodyNames = { obj.centralBodies };
            end
            for i = 1:length(bodyNames)
                if isa(bodyNames{i},'Body')
                    bodyNames{i} = bodyNames{i}.name;
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Propagator(obj);
            mp = horzcat(mp,{'centralBodies','accelerations'});
        end
        
    end
    
end

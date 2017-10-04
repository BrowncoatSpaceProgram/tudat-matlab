classdef RotationalPropagator < Propagator
    properties
        torques
    end
    
    methods
        function obj = RotationalPropagator()
            obj@Propagator(IntegratedStates.rotational);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Propagator(obj);
            mp = horzcat(mp,{'torques'});
        end

    end
    
end

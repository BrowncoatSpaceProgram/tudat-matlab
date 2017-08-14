classdef MassPropagator < Propagator
    properties
        massRateModels
    end
    
    methods
        function obj = MassPropagator()
            obj@Propagator(IntegratedStates.mass);
        end
        
        function s = struct(obj)
            s = struct@Propagator(obj);
            s = json.update(s,obj,'massRateModels');
        end

    end
    
end

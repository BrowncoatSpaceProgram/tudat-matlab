classdef HybridPropagator < Propagator
    properties
        propagators
    end
    
    methods
        function obj = HybridPropagator(varargin)
            obj@Propagator(IntegratedStates.hybrid);
            obj.propagators = varargin;
        end
        
        function s = struct(obj)
            s = struct@Propagator(obj);
            s = json.update(s,obj,'propagators');
        end

    end
    
end

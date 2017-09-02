classdef LagrangeInterpolator < Interpolator
    properties
        order
        boundaryHandling
    end
    
    methods
        function obj = LagrangeInterpolator(order)
            obj@Interpolator(Interpolators.lagrange);
            if nargin >= 1
                obj.order = order;
            end
        end
        
        function set.boundaryHandling(obj,value)
            if ~isa(value,'BoundaryHandlings')
                value = BoundaryHandlings(value);
            end
            obj.boundaryHandling = value;
        end
        
    end
        
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Interpolator(obj);
            mp = horzcat(mp,{'order'});
        end
        
    end
    
end

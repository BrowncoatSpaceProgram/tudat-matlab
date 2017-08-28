classdef ConstantAerodynamics < Aerodynamics
    properties
        forceCoefficients
        momentCoefficients
    end
    properties (Transient, Dependent)
        dragCoefficient
    end
    
    methods
        function value = get.dragCoefficient(obj)
            value = obj.forceCoefficients(1);
        end
        
        function set.dragCoefficient(obj,value)
            obj.forceCoefficients = [value 0 0];
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Aerodynamics(obj);
            mp = horzcat(mp,{'forceCoefficients'});
            if norm(obj.momentCoefficients) > 0  % moments
                mp = horzcat(mp,{'momentCoefficients','referenceLength','lateralReferenceLength',...
                    'momentReferencePoint'});
            end
        end
        
    end
    
end

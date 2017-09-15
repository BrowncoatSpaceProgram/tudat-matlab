classdef TabulatedAerodynamics < Aerodynamics
    properties
        independentVariableValues
        forceCoefficients
        momentCoefficients
        interpolator
    end
    
    methods
        function obj = TabulatedAerodynamics()
            obj@Aerodynamics(AerodynamicCoefficients.tabulated);
            obj.interpolator = Interpolator();
        end
        
    end
    
    methods (Hidden)
        function p = isPath(obj,property)
            p = strcmp(property,'forceCoefficients') && iscellstr(obj.forceCoefficients) || ...
                strcmp(property,'momentCoefficients') && iscellstr(obj.momentCoefficients);
        end
        
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Aerodynamics(obj);
            mp = horzcat(mp,{'independentVariableNames','forceCoefficients'});
            if ~isempty(obj.momentCoefficients)  % moments
                mp = horzcat(mp,{'momentCoefficients','referenceLength','lateralReferenceLength',...
                    'momentReferencePoint'});
            end
        end
        
    end
    
end

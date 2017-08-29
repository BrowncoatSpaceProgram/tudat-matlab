classdef TabulatedAerodynamics < Aerodynamics
    properties
        % numberOfDimensions
        independentVariableName
        independentVariables
        forceCoefficients
        momentCoefficients
        interpolator
    end
    
    methods
        function obj = TabulatedAerodynamics()
            obj@Aerodynamics(AerodynamicCoefficients.tabulated);
            obj.interpolator = Interpolator();
        end
        
        function set.independentVariableName(obj,value)
            if ~isa(value,'AerodynamicVariables')
                value = AerodynamicVariables(value);
            end
            obj.independentVariableName = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Aerodynamics(obj);
            mp = horzcat(mp,{'independentVariableName','independentVariables','forceCoefficients',...
                'interpolator'});
            if any(compute.normPerRows(obj.momentCoefficients) > 0)  % moments
                mp = horzcat(mp,{'momentCoefficients','referenceLength','lateralReferenceLength',...
                    'momentReferencePoint'});
            end
        end
        
    end
    
end

classdef Aerodynamics < jsonable
    properties
        coefficientsType
        referenceLength
        referenceArea
        lateralReferenceLength
        momentReferencePoint
        independentVariableNames
        areCoefficientsInAerodynamicFrame
        areCoefficientsInNegativeAxisDirection
        % controlSurfaceSettings
    end
    
    methods
        function obj = Aerodynamics(coefficientsType)
            if nargin >= 1
                obj.coefficientsType = coefficientsType;
            end
        end
        
        function set.coefficientsType(obj,value)
            if ~isa(value,'AerodynamicCoefficients')
                value = AerodynamicCoefficients(value);
            end
            obj.coefficientsType = value;
        end
        
        function set.independentVariableNames(obj,value)
            if ~iscell(value)
                value = {value};
            end
            for i = 1:length(value)
                if ~isa(value{i},'AerodynamicVariables')
                    value{i} = AerodynamicVariables(value{i});
                end
                obj.independentVariableNames{i} = value{i};
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
    
end

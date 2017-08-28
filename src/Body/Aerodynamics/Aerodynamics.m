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
            obj.coefficientsType = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
    
end

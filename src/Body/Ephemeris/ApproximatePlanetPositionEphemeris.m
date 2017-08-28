classdef ApproximatePlanetPositionEphemeris < Ephemeris
    properties
        bodyIdentifier
        useCircularCoplanarApproximation
    end
    
    methods
        function obj = ApproximatePlanetPositionEphemeris(bodyIdentifier,useCircularCoplanarApproximation)
            obj@Ephemeris(EphemerisTypes.approximatePlanetPositions);
            if nargin >= 1
                obj.bodyIdentifier = bodyIdentifier;
                if nargin >= 2
                    obj.useCircularCoplanarApproximation = useCircularCoplanarApproximation;
                end
            end
        end
        
        function set.bodyIdentifier(obj,value)
            if ~isa(value,'BodiesWithEphemerisData')
                value = BodiesWithEphemerisData(value);
            end
            obj.bodyIdentifier = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{'bodyIdentifier','useCircularCoplanarApproximation'});
        end
        
    end
    
end

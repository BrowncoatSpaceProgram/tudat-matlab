classdef KeplerEphemeris < Ephemeris
    properties
        initialStateInKeplerianElements
        epochOfInitialState
        centralBodyGravitationalParameter
        rootFinderAbsoluteTolerance
        rootFinderMaximumNumberOfIterations
    end
    
    methods
        function obj = KeplerEphemeris()
            obj@Ephemeris(EphemerisTypes.kepler);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{'initialStateInKeplerianElements','epochOfInitialState',...
                'centralBodyGravitationalParameter'});
        end
        
    end
    
end

classdef InterpolatedSpiceEphemeris < Ephemeris
    properties
        initialTime
        finalTime
        timeStep
        interpolator = Interpolator
        useLongDoubleStates
    end
    
    methods
        function obj = InterpolatedSpiceEphemeris()
            obj@Ephemeris(EphemerisTypes.interpolatedSpice);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{'initialTime','finalTime','timeStep'});
        end
        
    end
    
end

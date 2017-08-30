classdef InterpolatedSpiceEphemeris < DirectSpiceEphemeris
    properties
        initialTime
        finalTime
        timeStep
        interpolator
        useLongDoubleStates
    end
    
    methods
        function obj = InterpolatedSpiceEphemeris()
            obj@DirectSpiceEphemeris(EphemerisTypes.interpolatedSpice);
            obj.interpolator = Interpolator();
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@DirectSpiceEphemeris(obj);
            mp = horzcat(mp,{'initialTime','finalTime','timeStep'});
        end
        
    end
    
end

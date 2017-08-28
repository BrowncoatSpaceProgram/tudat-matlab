classdef TabulatedEphemeris < Ephemeris
    properties
        bodyStateHistory
        useLongDoubleStates
    end
    
    methods
        function obj = TabulatedEphemeris()
            obj@Ephemeris(EphemerisTypes.tabulated);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{'bodyStateHistory'});
        end
        
    end
    
end

classdef DirectSpiceEphemeris < Ephemeris
    properties
        correctForStellarAbberation
        correctForLightTimeAbberation
        convergeLighTimeAbberation
    end
    
    methods
        function obj = DirectSpiceEphemeris()
            obj@Ephemeris(EphemerisTypes.directSpice);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end

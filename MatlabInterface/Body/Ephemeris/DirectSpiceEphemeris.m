classdef DirectSpiceEphemeris < Ephemeris
    properties
        correctForStellarAberration
        correctForLightTimeAberration
        convergeLighTimeAberration
    end
    
    methods
        function obj = DirectSpiceEphemeris(type)
            if nargin == 0
                type = EphemerisTypes.directSpice;
            end
            obj@Ephemeris(type);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{});
        end
        
    end
    
end

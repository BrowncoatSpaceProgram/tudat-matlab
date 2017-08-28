classdef ConstantEphemeris < Ephemeris
    properties
        constantState
    end
    
    methods
        function obj = ConstantEphemeris(state)
            obj@Ephemeris(EphemerisTypes.constant);
            if nargin >= 1
                obj.constantState = state;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Ephemeris(obj);
            mp = horzcat(mp,{'constantState'});
        end
        
    end
    
end

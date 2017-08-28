classdef Ephemeris < jsonable
    properties
        type
        frameOrigin
        frameOrientation
        makeMultiArc
    end
    
    methods
        function obj = Ephemeris(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'EphemerisTypes')
                value = EphemerisTypes(value);
            end
            obj.type = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type'};
        end
        
    end
    
end

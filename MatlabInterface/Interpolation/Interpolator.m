classdef Interpolator < jsonable
    properties
        type
        lookupScheme
        useLongDoubleTimeStep
    end
    
    methods
        function obj = Interpolator(type)
            if nargin >= 1
                obj.type = type;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'Interpolators')
                value = Interpolators(value);
            end
            obj.type = value;
        end
        
        function set.lookupScheme(obj,value)
            if ~isa(value,'LookupSchemes')
                value = LookupSchemes(value);
            end
            obj.lookupScheme = value;
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type'};
        end
        
    end
    
end

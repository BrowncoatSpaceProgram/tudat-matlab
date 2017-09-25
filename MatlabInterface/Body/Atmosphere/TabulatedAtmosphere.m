classdef TabulatedAtmosphere < Atmosphere
    properties
        file
    end
    
    methods
        function obj = TabulatedAtmosphere(file)
            obj@Atmosphere(AtmosphereModels.tabulated);
            if nargin >= 1
                obj.file = file;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Atmosphere(obj);
            mp = horzcat(mp,{'file'});
        end
        
        function p = isPath(obj,property)
            p = strcmp(property,'file');
        end
        
    end
    
end

classdef NRLMSISE00Atmosphere < Atmosphere
    properties
        spaceWeatherFile
    end
    
    methods
        function obj = NRLMSISE00Atmosphere(spaceWeatherFile)
            obj@Atmosphere(AtmosphereModels.nrlmsise00);
            if nargin >= 1
                obj.spaceWeatherFile = spaceWeatherFile;
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Atmosphere(obj);
            mp = horzcat(mp,{'spaceWeatherFile'});
        end
        
        function p = isPath(obj,property)
            p = strcmp(property,'spaceWeatherFile');
        end
        
    end
    
end

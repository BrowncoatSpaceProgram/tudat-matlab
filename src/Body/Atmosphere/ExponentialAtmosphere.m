classdef ExponentialAtmosphere < Atmosphere
    properties
        densityScaleHeight
        constantTemperature
        densityAtZeroAltitude
        specificGasConstant
    end
    
    methods
        function obj = ExponentialAtmosphere()
            obj@Atmosphere(AtmosphereModels.exponential);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Atmosphere(obj);
            mp = horzcat(mp,{'densityScaleHeight','constantTemperature','densityAtZeroAltitude',...
                'specificGasConstant'});
        end
        
    end
    
end

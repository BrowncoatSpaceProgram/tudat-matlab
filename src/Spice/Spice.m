classdef Spice < jsonable
    properties
        alternativeKernels
        kernels
        preloadKernels
        interpolationOffsets
        interpolationStep
    end
    properties (Dependent)
        useStandardKernels
    end
    
    methods
        function value = get.useStandardKernels(obj)
            value = isempty(obj.kernels);
        end
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'useStandardKernels'};
            if obj.useStandardKernels == false
                mp = horzcat(mp,{'kernels'});
            end
        end
        
    end
    
end

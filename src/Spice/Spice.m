classdef Spice < jsonable
    properties
        kernels
        preloadKernels
        preloadOffsets
    end
    
    methods
        function obj = Spice(varargin)
            if islogical(varargin{end})
                useCustomKernelsDirectory = varargin{end};
                varargin(end) = [];
            else
                useCustomKernelsDirectory = false;
            end
            if ~useCustomKernelsDirectory
                for i = 1:length(varargin)
                    varargin{i} = ['${SPICE_KERNELS_PATH}/' varargin{i}];
                end
            end
            obj.kernels = varargin;
        end
        
        function mp = getMandatoryProperties(obj)
            mp = {'kernels'};
        end
        
    end
    
end

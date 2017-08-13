classdef Spice
    properties
        kernels
        preloadKernels
        preloadOffsets
    end
    properties (Dependent)
        preloadOffset
        startPreloadOffset
        endPreloadOffset
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
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'kernels');
            s = json.update(s,obj,'preloadKernels',false);
            s = json.update(s,obj,'preloadOffsets',false);
        end
        
    end
    
end

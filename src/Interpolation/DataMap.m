classdef DataMap < jsonable
    properties
        map
    end
    
    methods
        function obj = DataMap(varargin)
            if nargin >= 1
                obj.map = containers.Map(varargin{:});
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'map'};
        end
        
    end
    
end

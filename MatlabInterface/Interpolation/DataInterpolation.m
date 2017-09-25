classdef DataInterpolation < jsonable
    properties
        data
        interpolator
    end
    
    methods
        function obj = DataInterpolation(data,interpolator)
            obj.data = DataMap();
            obj.interpolator = Interpolator();
            if nargin >= 1
                obj.data = data;
                if nargin >= 2
                    obj.interpolator = interpolator;
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'data','interpolator'};
        end
        
    end
    
end

classdef ModelInterpolation < jsonable
    properties
        initialTime
        finalTime
        timeStep
        interpolator = Interpolator
    end
    
    methods
        function obj = ModelInterpolation(initialTime,finalTime,timeStep,interpolator)
            if nargin >= 1
                obj.initialTime = initialTime;
                if nargin >= 2
                    obj.finalTime = finalTime;
                    if nargin >= 3
                        obj.timeStep = timeStep;
                        if nargin >= 4
                            obj.interpolator = interpolator;
                        end
                    end
                end
            end
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {};
        end
        
    end
    
end

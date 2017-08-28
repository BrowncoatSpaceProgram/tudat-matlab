classdef Integrator < jsonable
    properties
        type
        initialTime
        stepSize
        saveFrequency
    end
    
    methods
        function obj = Integrator(integratorType,fixedStepSize)
            if nargin >= 2
                obj.stepSize = fixedStepSize;
            end
            if nargin >= 1
                obj.type = integratorType;
            else
                obj.type = Integrators.rungeKutta4;
            end
        end
        
        function set.type(obj,value)
            if ~isa(value,'Integrators')
                value = Integrators(value);
            end
            obj.type = char(value);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type','stepSize'};
        end

    end
    
end

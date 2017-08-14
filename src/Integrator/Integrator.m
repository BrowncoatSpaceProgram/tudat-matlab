classdef Integrator < handle
    properties
        type
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
        
        function s = struct(obj)
            s = [];
            s = json.update(s,obj,'type');
            s = json.update(s,obj,'stepSize');
            s = json.update(s,obj,'saveFrequency',false);
        end

    end
    
end

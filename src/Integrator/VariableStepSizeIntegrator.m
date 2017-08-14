classdef VariableStepSizeIntegrator < Integrator
    properties
        rungeKuttaCoefficientSet
        minimumStepSize
        maximumStepSize
        relativeErrorTolerance
        absoluteErrorTolerance
        safetyFactorForNextStepSize
        maximumFactorIncreaseForNextStepSize
        minimumFactorDecreaseForNextStepSize
    end
    properties (Dependent)
        initialStepSize
        errorTolerance
    end
    
    methods
        function obj = VariableStepSizeIntegrator(rungeKuttaCoefficientSet)
            obj@Integrator(Integrators.rungeKuttaVariableStepSize);
            obj.rungeKuttaCoefficientSet = rungeKuttaCoefficientSet;
        end
        
        function set.rungeKuttaCoefficientSet(obj,value)
            if ~isa(value,'RungeKuttaCoefficientSets')
                value = RungeKuttaCoefficientSets(value);
            end
            obj.rungeKuttaCoefficientSet = char(value);
        end
        
        function value = get.initialStepSize(obj)
            value = obj.stepSize;
        end
        
        function set.initialStepSize(obj,value)
            obj.stepSize = value;
        end
        
        function value = get.errorTolerance(obj)
            if obj.relativeErrorTolerance == obj.absoluteErrorTolerance
                value = obj.relativeErrorTolerance;
            else
                error('Could not determine error tolerance because relative and absolute error tolerances differ.');
            end
        end
        
        function set.errorTolerance(obj,value)
            obj.relativeErrorTolerance = value;
            obj.absoluteErrorTolerance = value;
        end
        
        function s = struct(obj)
            s = struct@Integrator(obj);
            s = rmfield(s,'stepSize');
            s = json.update(s,obj,'initialStepSize');
            s = json.update(s,obj,'rungeKuttaCoefficientSet');
            s = json.update(s,obj,'minimumStepSize');
            s = json.update(s,obj,'maximumStepSize');
            s = json.update(s,obj,'relativeErrorTolerance',false);
            s = json.update(s,obj,'absoluteErrorTolerance',false);
            s = json.update(s,obj,'safetyFactorForNextStepSize',false);
            s = json.update(s,obj,'maximumFactorIncreaseForNextStepSize',false);
            s = json.update(s,obj,'minimumFactorDecreaseForNextStepSize',false);
        end
        
    end
    
end

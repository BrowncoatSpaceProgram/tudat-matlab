classdef VariableStepSizeIntegrator < Integrator
    properties
        initialStepSize
        rungeKuttaCoefficientSet
        minimumStepSize
        maximumStepSize
        relativeErrorTolerance
        absoluteErrorTolerance
        safetyFactorForNextStepSize
        maximumFactorIncreaseForNextStepSize
        minimumFactorDecreaseForNextStepSize
    end
    properties (Transient, Dependent)
        errorTolerance
    end
    
    methods
        function obj = VariableStepSizeIntegrator(rungeKuttaCoefficientSet)
            obj@Integrator(Integrators.rungeKuttaVariableStepSize);
            if nargin >= 1
                obj.rungeKuttaCoefficientSet = rungeKuttaCoefficientSet;
            end
        end
        
        function set.rungeKuttaCoefficientSet(obj,value)
            if ~isa(value,'RungeKuttaCoefficientSets')
                value = RungeKuttaCoefficientSets(value);
            end
            obj.rungeKuttaCoefficientSet = value;
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

    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = {'type','initialStepSize','rungeKuttaCoefficientSet','minimumStepSize','maximumStepSize'};
        end
        
    end
    
end

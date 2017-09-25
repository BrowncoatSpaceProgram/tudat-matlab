function [failCount,testOutput] = unitTestIntegrator

tudat.load();


% Create input files for tests

% Test 1: integrator types
test.createInputForEnum(?Integrators,fullfile(mfilename,'types'));

% Test 2: Runge-Kutta coefficient sets
test.createInputForEnum(?RungeKuttaCoefficientSets,fullfile(mfilename,'rksets'));

% Test 3: Euler
int = Integrator();
int.type = Integrators.euler;
int.initialTime = 3;
int.stepSize = 1.4;
test.createInput(int,fullfile(mfilename,'euler'));

% Test 4: rungeKutta4
int = Integrator();
int.type = Integrators.rungeKutta4;
int.initialTime = 3;
int.stepSize = 1.4;
int.saveFrequency = 2;
int.assessPropagationTerminationConditionDuringIntegrationSubsteps = true;
test.createInput(int,fullfile(mfilename,'rungeKutta4'));

% Test 5: rungeKuttaVariableStepSize
int = VariableStepSizeIntegrator();
int.type = Integrators.rungeKuttaVariableStepSize;
int.rungeKuttaCoefficientSet = RungeKuttaCoefficientSets.rungeKuttaFehlberg78;
int.initialTime = -0.3;
int.minimumStepSize = 0.4;
int.initialStepSize = 1.4;
int.maximumStepSize = 2.4;
int.relativeErrorTolerance = 1e-4;
int.absoluteErrorTolerance = 1e-2;
int.safetyFactorForNextStepSize = 2;
int.maximumFactorIncreaseForNextStepSize = 10;
int.minimumFactorDecreaseForNextStepSize = 0.1;
test.createInput(int,fullfile(mfilename,'rungeKuttaVariableStepSize'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


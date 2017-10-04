function [failCount,testOutput] = unitTestVariable

tudat.load();


% Create input files for tests

% Test 1: variable types
test.createInputForEnum(?Variables,fullfile(mfilename,'types'));

% Test 2: dependent variable types
test.createInputForEnum(?DependentVariables,fullfile(mfilename,'dependentTypes'));

% Test 3: dependent variable
test.createInput(Variable('body.altitude-Earth'),fullfile(mfilename,'dependent'));

% Test 4: acceleration variable
test.createInput(Variable('body.accelerationNorm@thrust-body'),fullfile(mfilename,'acceleration'));

% Test 5: torque variable
test.createInput(Variable('Moon.torque@secondOrderGravitational-Earth(3)'),fullfile(mfilename,'torque'));

% Test 6: intermediate aerodynamic rotation matrix variable
var = Variable();
var.body = 'vehicle';
var.dependentVariableType = DependentVariables.intermediateAerodynamicRotationMatrix;
var.baseFrame = AerodynamicsReferenceFrames.body;
var.targetFrame = AerodynamicsReferenceFrames.intertial;
var.componentIndex = 8;
test.createInput(var,fullfile(mfilename,'intermediateAerodynamicRotationMatrix'));

% Test 7: relative body aerodynamic orientation angle variable
var = Variable();
var.body = 'vehicle';
var.dependentVariableType = DependentVariables.relativeBodyAerodynamicOrientationAngle;
var.angle = AerodynamicsReferenceFrameAngles.bank;
test.createInput(var,fullfile(mfilename,'relativeBodyAerodynamicOrientationAngle'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


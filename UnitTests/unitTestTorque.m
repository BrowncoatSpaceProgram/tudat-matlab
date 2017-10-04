function [failCount,testOutput] = unitTestTorque

tudat.load();


% Create input files for tests

% Test 1: torque types
test.createInputForEnum(?Torques,fullfile(mfilename,'types'));

% Test 2: second order gravitational torque
test.createInput(SecondOrderGravitationalTorque(),fullfile(mfilename,'secondOrderGravitational'));

% Test 3: aerodynamic torque
test.createInput(AerodynamicTorque(),fullfile(mfilename,'aerodynamic'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


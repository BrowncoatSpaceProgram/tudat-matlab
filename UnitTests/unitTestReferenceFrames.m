function [failCount,testOutput] = unitTestReferenceFrames

tudat.load();


% Create input files for tests

% Test 1: aerodynamic reference frames
test.createInputForEnum(?AerodynamicsReferenceFrames,fullfile(mfilename,'aerodynamic'));

% Test 2: aerodynamic reference frames angles
test.createInputForEnum(?AerodynamicsReferenceFrameAngles,fullfile(mfilename,'aerodynamicAngles'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


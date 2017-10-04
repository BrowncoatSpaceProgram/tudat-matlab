function [failCount,testOutput] = unitTestMassRateModel

tudat.load();


% Create input files for tests

% Test 1: mass rate model types
test.createInputForEnum(?MassRateModels,fullfile(mfilename,'types'));

% Test 2: from thrust mass rate model
mrm = FromThrustMassRateModel();
mrm.useAllThrustModels = false;
mrm.associatedThrustSource = 'booster2';
test.createInput(mrm,fullfile(mfilename,'fromThrust'));

% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


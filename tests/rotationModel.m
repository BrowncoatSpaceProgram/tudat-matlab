function [failCount,testOutput] = rotationModel(generateInput)

tudat.load();

if nargin < 1
    generateInput = false;
end

% Create input files for tests
if generateInput
    % Test 1: rotation model types
    test.createInputForEnum(?RotationModels,fullfile(mfilename,'types'));
    
    % Test 2: simple rotation model
    rm = SimpleRotationModel();
    rm.originalFrame = 'ECLIPJ2000';
    rm.targetFrame = 'IAU_Earth';
    rm.initialTime = 42;
    rm.rotationRate = 2e-5;
    test.createInput(rm,fullfile(mfilename,'simple'));
    
    % Test 3: spice rotation model
    rm = SpiceRotationModel();
    rm.originalFrame = 'foo';
    rm.targetFrame = 'oof';
    test.createInput(rm,fullfile(mfilename,'spice'));
end

% Run tests
[failCount,testOutput] = test.runUnitTest(mfilename);


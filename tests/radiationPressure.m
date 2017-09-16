function [failCount,testOutput] = radiationPressure(generateInput)

tudat.load();

if nargin < 1
    generateInput = false;
end

% Create input files for tests
if generateInput
    % Test 1: radiation pressure types
    test.createInputForEnum(?RadiationPressureTypes,fullfile(mfilename,'types'));
    
    % Test 2: cannon ball radiation pressure
    rp = CannonBallRadiationPressure();
    rp.sourceBody = 'Sun';
    rp.referenceArea = 2;
    rp.radiationPressureCoefficient = 1.5;
    rp.occultingBodies = {'Earth','Moon'};
    test.createInput(rp,fullfile(mfilename,'cannonBall'));
end

% Run tests
[failCount,testOutput] = test.runUnitTest(mfilename);


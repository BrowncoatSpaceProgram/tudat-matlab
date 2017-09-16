function [failCount,testOutput] = radiationPressure

tudat.load();


% Create input files for tests

% Test 1: radiation pressure types
test.createInputForEnum(?RadiationPressureTypes,fullfile(mfilename,'types'));

% Test 2: cannon ball radiation pressure
rp = CannonBallRadiationPressure();
rp.sourceBody = 'Sun';
rp.referenceArea = 2;
rp.radiationPressureCoefficient = 1.5;
rp.occultingBodies = {'Earth','Moon'};
test.createInput(rp,fullfile(mfilename,'cannonBall'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


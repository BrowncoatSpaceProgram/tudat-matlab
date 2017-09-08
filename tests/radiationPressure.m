function [failcount,issueURL] = radiationPressure

tudat.load();

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

[failcount,issueURL] = test.runUnitTest(mfilename);


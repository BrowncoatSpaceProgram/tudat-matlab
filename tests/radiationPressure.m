function failcount = radiationPressure

tudat.load();

% Test 1: radiation pressure types
test.createInputForEnum(?RadiationPressureTypes,[mfilename '_types']);

% Test 2: cannon ball radiation pressure
rp = CannonBallRadiationPressure();
rp.sourceBody = 'Sun';
rp.referenceArea = 2;
rp.radiationPressureCoefficient = 1.5;
rp.occultingBodies = {'Earth','Moon'};
test.createInput(rp,[mfilename '_cannonBall']);


% Run tests

failcount = test.runUnitTest(mfilename);


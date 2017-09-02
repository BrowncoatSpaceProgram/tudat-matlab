function failcount = rotationModel

tudat.load();

% Test 1: rotation model types
test.createInputForEnum(?RotationModels,[mfilename '_types']);

% Test 2: simple rotation model
rm = SimpleRotationModel();
rm.originalFrame = 'A';
rm.targetFrame = 'B';
rm.initialTime = 42;
rm.rotationRate = 2e-5;
rm.initialOrientation = [1 0 0; 0 sqrt(2)/2 -sqrt(2)/2; 0 -sqrt(2)/2 sqrt(2)/2];
test.createInput(rm,[mfilename '_simple']);

% Test 3: spice rotation model
rm = SpiceRotationModel();
rm.originalFrame = 'foo';
rm.targetFrame = 'oof';
test.createInput(rm,[mfilename '_spice']);


% Run tests

failcount = test.runUnitTest(mfilename);


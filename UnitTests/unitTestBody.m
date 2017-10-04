function [failCount,testOutput] = unitTestBody

tudat.load();


% Create input files for tests

% Test 1: body settings
body = Body();
body.mass = 3000;
body.referenceArea = 5;
body.aerodynamics.dragCoefficient = 1.7;
body.atmosphere.type = AtmosphereModels.nrlmsise00;
body.ephemeris = ConstantEphemeris([0 1 0 -0.1 0 0]);
body.gravityField = PointMassGravityField(4e14);
body.gravityFieldVariation = {BasicSolidBodyGravityFieldVariation()};
body.gravityFieldVariation{1}.deformingBodies = {'Moon'};
body.gravityFieldVariation{1}.loveNumbers = [[1+1i 2+1i 3+1i]; [0.5i 2i 4i]; [0 0 1i]];
body.gravityFieldVariation{1}.referenceRadius = 5e6;
body.radiationPressure.Sun.radiationPressureCoefficient = 1.3;
body.rotationModel = SpiceRotationModel();
body.rotationModel.originalFrame = 'A';
body.rotationModel.targetFrame = 'B';
body.shapeModel = SphericalShapeModel(5e6);
test.createInput(body,fullfile(mfilename,'body'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


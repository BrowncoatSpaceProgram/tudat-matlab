function failcount = gravityField

tudat.load();

% Test 1: gravity field types
test.createInputForEnum(?GravityFields,[mfilename '_types']);

% Test 2: spherical harmonic models
test.createInputForEnum(?SphericalHarmonicModels,[mfilename '_sphericalHarmonicModels']);

% Test 3: point mass gravity field
gf = PointMassGravityField();
gf.gravitationalParameter = 4e14;
test.createInput(gf,[mfilename '_pointMass']);

% Test 4: point mass Spice gravity field
gf = PointMassSpiceGravityField();
test.createInput(gf,[mfilename '_pointMassSpice']);

% Test 5: spherical harmonic gravity field (from named model)
gf = SphericalHarmonicGravityField('ggm02c');
test.createInput(gf,[mfilename '_sphericalHarmonic_model']);

% Test 6: spherical harmonic gravity field (from file)
gf = SphericalHarmonicGravityField();
gf.file = 'sh.txt';
gf.associatedReferenceFrame = 'IAU_Earth';
gf.maximumDegree = 2;
gf.maximumOrder = 1;
test.createInput(gf,[mfilename '_sphericalHarmonic_file']);
test.createInput('0.3986004418E15 6378137.0\n2 0 -0.484E-03 0.000E+00\n2 1 -0.186E-09 0.119E-08\n2 2 0.243E-05 -0.140E-05\n3 0 0.957E-06 0.000E+00\n3 1 0.202E-05 0.248E-06\n3 2 0.904E-06 -0.619E-06\n','sh.txt',false);


% Test 7: spherical harmonic gravity field (from file, manual parameters)
gf.file = 'sh_manualparam.txt';
gf.gravitationalParameterIndex = -1;
gf.referenceRadiusIndex = -1;
gf.gravitationalParameter = 4e14;
gf.referenceRadius = 6.4e6;
test.createInput(gf,[mfilename '_sphericalHarmonic_file_manualparam']);
test.createInput('2 0 -0.484E-03 0.000E+00\n2 1 -0.186E-09 0.119E-08\n2 2 0.243E-05 -0.140E-05\n3 0 0.957E-06 0.000E+00\n3 1 0.202E-05 0.248E-06\n3 2 0.904E-06 -0.619E-06\n','sh_manualparam.txt',false);

% Test 8: spherical harmonic gravity field (direct)
gf = SphericalHarmonicGravityField();
gf.associatedReferenceFrame = 'IAU_Earth';
gf.gravitationalParameter = 4e14;
gf.referenceRadius = 6.4e6;
gf.cosineCoefficients = [1 0; 0 0];
gf.sineCoefficients = [0 0; 0 0];
test.createInput(gf,[mfilename '_sphericalHarmonic_direct']);


% Run tests

failcount = test.runUnitTest(mfilename);


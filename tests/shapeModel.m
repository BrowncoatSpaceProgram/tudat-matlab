function failcount = shapeModel

tudat.load();

% Test 1: rotation model types
test.createInputForEnum(?ShapeModels,[mfilename '_types']);

% Test 2: spherical shape model
sm = SphericalShapeModel();
sm.radius = 6.4e6;
test.createInput(sm,[mfilename '_spherical']);

% Test 3: spherical Spice shape model
sm = SphericalSpiceShapeModel();
test.createInput(sm,[mfilename '_sphericalSpice']);

% Test 4: oblate spherical shape model
sm = OblateSphericalShapeModel();
sm.equatorialRadius = 6.378e6;
sm.flattening = 0.0034;
test.createInput(sm,[mfilename '_oblateSpherical']);


% Run tests

failcount = test.runUnitTest(mfilename);


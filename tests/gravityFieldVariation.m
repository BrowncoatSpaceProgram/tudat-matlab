function failcount = gravityFieldVariation

tudat.load();

% Test 1: body deformation types
test.createInputForEnum(?BodyDeformations,fullfile(mfilename,'bodyDeformationTypes'));

% Test 2: basic solid body gravity field variation
gfv = BasicSolidBodyGravityFieldVariation();
gfv.deformingBodies = 'Moon';
gfv.loveNumbers = [[1+2i 2-1i 0.3-5i]; [0.5i 2i 4-2i]; [-3 -5+1i 6+0.5i]];
gfv.referenceRadius = 6.4e6;
test.createInput(gfv,fullfile(mfilename,'basicSolidBody'));

% Test 3: tabulated field variation
gfv = TabulatedGravityFieldVariation();
gfv.cosineCoefficientCorrections = containers.Map({0, 1},{[0 1 2], [0 0 -1]});
gfv.sineCoefficientCorrections = containers.Map({0, 1},{[-1 4 5], [3 2 0.5]});
gfv.minimumDegree = 4;
gfv.minimumOrder = 2;
gfv.modelInterpolation.interpolator.type = 'cubicSpline';
test.createInput(gfv,fullfile(mfilename,'tabulated'));


% Run tests

failcount = test.runUnitTest(mfilename);


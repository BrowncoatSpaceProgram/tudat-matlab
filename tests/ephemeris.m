function [failCount,testOutput] = ephemeris

tudat.load();


% Create input files for tests

% Test 1: ephemeris types
test.createInputForEnum(?EphemerisTypes,fullfile(mfilename,'types'));

% Test 2: bodies with ephemeris data
test.createInputForEnum(?BodiesWithEphemerisData,fullfile(mfilename,'bodiesWithEphemerisData'));

% Test 3: approximate planet position ephemeris
eph = ApproximatePlanetPositionEphemeris();
eph.bodyIdentifier = BodiesWithEphemerisData.earthMoonBarycenter;
eph.useCircularCoplanarApproximation = false;
test.createInput(eph,fullfile(mfilename,'approximatePlanetPositions'));

% Test 4: direct Spice ephemeris
eph = DirectSpiceEphemeris();
eph.frameOrigin = 'Foo';
eph.frameOrientation = 'FOO';
eph.correctForStellarAberration = true;
eph.correctForLightTimeAberration = false;
eph.convergeLighTimeAberration = true;
test.createInput(eph,fullfile(mfilename,'directSpice'));

% Test 5: tabulated ephemeris
eph = TabulatedEphemeris();
eph.bodyStateHistory = containers.Map({0 1 2},{[1 0 0 0 -0.4 0] [3 0 0 0 -0.2 0] [4 0 0 0 -0.1 0]});
test.createInput(eph,fullfile(mfilename,'tabulated'));

% Test 6: interpolated spice ephemeris
eph = InterpolatedSpiceEphemeris();
eph.makeMultiArc = true;
eph.initialTime = 2;
eph.finalTime = 100;
eph.timeStep = 10;
eph.frameOrigin = 'Foo';
eph.frameOrientation = 'FOO';
eph.interpolator = LagrangeInterpolator(4);
eph.correctForLightTimeAberration = true;
test.createInput(eph,fullfile(mfilename,'interpolatedSpice'));

% Test 7: constant ephemeris
eph = ConstantEphemeris([0 1 0 -0.1 0 0]);
test.createInput(eph,fullfile(mfilename,'constant'));

% Test 8: kepler ephemeris
eph = KeplerEphemeris();
eph.initialStateInKeplerianElements = [7e6 0.1 0 0 0 0];
eph.epochOfInitialState = -4e4;
eph.centralBodyGravitationalParameter = 4e14;
eph.frameOrigin = 'Foo';
eph.frameOrientation = 'FOO';
eph.rootFinderAbsoluteTolerance = 1e-9;
eph.rootFinderMaximumNumberOfIterations = 100;
test.createInput(eph,fullfile(mfilename,'kepler'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


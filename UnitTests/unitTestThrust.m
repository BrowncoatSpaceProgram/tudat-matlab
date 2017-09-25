function [failCount,testOutput] = unitTestThrust

tudat.load();


% Create input files for tests

% Test 1: thrust direction types
test.createInputForEnum(?ThrustDirections,fullfile(mfilename,'directionTypes'));

% Test 2: thrust magnitude types
test.createInputForEnum(?ThrustMagnitudes,fullfile(mfilename,'magnitudeTypes'));

% Test 3: thrust frame types
test.createInputForEnum(?ThrustFrames,fullfile(mfilename,'frameTypes'));

% Test 4: thrust from direction and magnitude
thr = Thrust();
thr.direction.type = ThrustDirections.colinearWithStateSegment;
thr.direction.relativeBody = Mercury;
thr.direction.colinearWithVelocity = true;
thr.direction.towardsRelativeBody = false;
thr.magnitude = FromBodyThrustMagnitude();
thr.magnitude.useAllEngines = false;
thr.magnitude.originID = 'booster';
test.createInput(thr,fullfile(mfilename,'directionMagnitude'));

% Test 5: interpolated thrust
thr = Thrust();
thr.dataInterpolation.data = HermiteData({0, 6068, 6097},...
    {[0 0 5], [0 1 5], [1 0 5]},{[0 0.1 0], [0.1 -0.1 0], [-0.02 0 0]});
thr.dataInterpolation.interpolator.type = Interpolators.hermiteSpline;
thr.specificImpulse = 3000;
thr.frame = ThrustFrames.intertial;
thr.centralBody = Moon;
test.createInput(thr,fullfile(mfilename,'interpolated'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


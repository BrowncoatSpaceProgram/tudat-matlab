function [failCount,testOutput] = unitTestAcceleration

tudat.load();


% Create input files for tests

% Test 1: acceleration types
test.createInputForEnum(?Accelerations,fullfile(mfilename,'types'));

% Test 2: sphericalHarmonicGravity
acc = SphericalHarmonicGravity(7,2);
test.createInput(acc,fullfile(mfilename,'sphericalHarmonicGravity'));

% Test 3: mutualSphericalHarmonicGravity
acc = MutualSphericalHarmonicGravity;
acc.maximumDegreeOfBodyExertingAcceleration = 7;
acc.maximumOrderOfBodyExertingAcceleration = 0;
acc.maximumDegreeOfBodyUndergoingAcceleration = 3;
acc.maximumOrderOfBodyUndergoingAcceleration = 2;
acc.maximumDegreeOfCentralBody = 5;
acc.maximumOrderOfCentralBody = 4;
test.createInput(acc,fullfile(mfilename,'mutualSphericalHarmonicGravity'));

% Test 4: relativisticCorrection
acc = RelativisticCorrectionAcceleration();
acc.calculateSchwarzschildCorrection = true;
acc.calculateLenseThirringCorrection = false;
acc.calculateDeSitterCorrection = true;
acc.primaryBody = Mars;
acc.centralBodyAngularMomentum = [7e-9 8e-10 5e-5];
test.createInput(acc,fullfile(mfilename,'relativisticCorrection'));

% Test 5: empirical
acc = EmpiricalAcceleration();
acc.constantAcceleration = [0.4 -0.1 0.05];
acc.sineAcceleration = [0 0.02 0];
acc.cosineAcceleration = [-0.01 0 0];
test.createInput(acc,fullfile(mfilename,'empirical'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


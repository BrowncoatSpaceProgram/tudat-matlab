function [failCount,testOutput] = unitTestSpice

tudat.load();


% Create input files for tests

% Test 1: standard kernels
spice = Spice();
spice.preloadEphemeris = true;
spice.interpolationOffsets = [10,400];
test.createInput(spice,fullfile(mfilename,'standard'));

% Test 2: alternative kernels
spice = Spice();
spice.alternativeKernels = {'foo.txt','oof.txt'};
spice.preloadEphemeris = false;
test.createInput(spice,fullfile(mfilename,'alternative'));

% Test 3: custom kernels
spice = Spice();
spice.kernels = {'foo.txt'};
spice.preloadEphemeris = true;
spice.interpolationStep = 9;
test.createInput(spice,fullfile(mfilename,'custom'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


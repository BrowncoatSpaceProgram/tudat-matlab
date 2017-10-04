function [failCount,testOutput] = unitTestInterpolation

tudat.load();


% Create input files for tests

% Test 1: interpolator types
test.createInputForEnum(?Interpolators,fullfile(mfilename,'types'));

% Test 2: lookup schemes
test.createInputForEnum(?LookupSchemes,fullfile(mfilename,'lookupSchemes'));

% Test 3: boundary handlings
test.createInputForEnum(?BoundaryHandlings,fullfile(mfilename,'boundaryHandlings'));

% Test 4: interpolator
int = Interpolator(Interpolators.piecewiseConstant);
int.lookupScheme = LookupSchemes.binarySearch;
int.useLongDoubleTimeStep = true;
test.createInput(int,fullfile(mfilename,'interpolator'));

% Test 5: Lagrange interpolator
test.createInput(LagrangeInterpolator(8),fullfile(mfilename,'lagrangeInterpolator'));

% Test 6: model interpolation
mint = ModelInterpolation(-5,5,0.5,Interpolator(Interpolators.linear));
test.createInput(mint,fullfile(mfilename,'modelInterpolation'));

% Test 7: data map
test.createInput(DataMap({1,2},{[0.5 1.5],[1.5 2.5]}),fullfile(mfilename,'dataMap'));

% Test 8: from file data map
test.createInput(FromFileDataMap('thrustValues.txt'),fullfile(mfilename,'fromFileDataMap'));

% Test 9: independent-dependent data map
dat = IndependentDependentDataMap();
dat.independentVariableValues = [1; 2];
dat.dependentVariableValues = [[0.5 1.5]; [1.5 2.5]];
test.createInput(dat,fullfile(mfilename,'independentDependentDataMap'));

% Test 10: Hermite data map
dat = HermiteData({1,2},{[0.5 1.5],[1.5 2.5]});
dat.dependentVariableFirstDerivativeValues = [[1 0.8]; [0.5 0.4]];
test.createInput(dat,fullfile(mfilename,'hermiteDataMap'));

% Test 11: data interpolation
dat = FromFileDataMap('thrustValues.txt');
int = LagrangeInterpolator(4);
test.createInput(DataInterpolation(dat,int),fullfile(mfilename,'dataInterpolation'));

% Copy auxiliary input files
test.copyAuxiliaryInputFiles(mfilename('fullpath'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


function [failCount,testOutput] = unitTestExport

tudat.load();


% Create input files for tests

% Test 1: full result
result = Result('independent','body.altitude-Earth');
result.header = ['Foo' char(10)];
result.epochsInFirstColumn = false;
exp = Export('full.txt',result);
test.createInput(exp,fullfile(mfilename,'fullResult'));

% Test 2: partial result
result = Result('body.altitude-Earth');
result.epochsInFirstColumn = true;
result.onlyInitialStep = true;
result.onlyFinalStep = true;
result.numericalPrecision = 6;
exp = Export('partial.txt',result);
test.createInput(exp,fullfile(mfilename,'partialResult'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


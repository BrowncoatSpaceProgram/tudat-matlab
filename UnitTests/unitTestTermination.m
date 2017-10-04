function [failCount,testOutput] = unitTestTermination

tudat.load();


% Create input files for tests

% Test 1: single condition
c1 = Variable('body.altitude-Earth') < 105e3;
test.createInput(c1,fullfile(mfilename,'single'));

% Test 2: multiple conditions (any of)
c2 = Variable('cpuTime') > 60;
test.createInput(c1 | c2,fullfile(mfilename,'anyOf'));

% Test 3: multiple conditions (all of)
c3 = Variable('body.machNumber') > 1;
test.createInput(c1 & c3,fullfile(mfilename,'allOf'));

% Test 4: multiple conditions (combined)
c4 = Variable('independent') > 86400;
c5 = Variable('body.acceleration@aerodynamic-Earth(1)') < 0;
c6 = Variable('body.acceleration@aerodynamic-Earth[1]') < 0;
test.createInput(c4 | c2 | ( ( c1 | c5 | c6 ) & c3 ),fullfile(mfilename,'combined'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


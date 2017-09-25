function [failCount,testOutput] = unitTestState

tudat.load();


% Create input files for tests

% Test 1: state types
test.createInputForEnum(?States,fullfile(mfilename,'types'));

% Test 2: direct Cartesian state
test.createInput([1.5 0 0 0 -0.02 0],fullfile(mfilename,'direct'));

% Test 3: Cartesian state
car = State();
car.x = 1.5;
car.vy = -0.02;
test.createInput(car,fullfile(mfilename,'cartesian'));


% Test 4: Keplerian state

mu = 4e8;
R = 0.5;

% Full Keplerian state
kep = State();
kep.semiMajorAxis = 3;
kep.eccentricity = 0.2;
kep.inclination = 0.3;
kep.argumentOfPeriapsis = 0.4;
kep.longitudeOfAscendingNode = 0.5;
kep.trueAnomaly = 0.6;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian0'));

% Only radius
kep = State();
kep.radius = 2;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian1'));

% Only altitude
kep = State();
kep.altitude = 2 - R;
kep.centralBodyGravitationalParameter = mu;
kep.centralBodyAverageRadius = R;
test.createInput(kep,fullfile(mfilename,'keplerian2'));

% Only mean motion
kep = State();
kep.meanMotion = 0.01;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian3'));

% Only orbital period
kep = State();
kep.period = 0.05;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian4'));

% Peri/apo distances
kep = State();
kep.apoapsisDistance = 3;
kep.periapsisDistance = 2;
kep.inclination = 0.3;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian5'));

% Peri/apo altitudes
kep = State();
kep.apoapsisAltitude = 3 - R;
kep.periapsisAltitude = 2 - R;
kep.argumentOfPeriapsis = 0.4;
kep.longitudeOfAscendingNode = 0.5;
kep.trueAnomaly = 0.6;
kep.centralBodyGravitationalParameter = mu;
kep.centralBodyAverageRadius = R;
test.createInput(kep,fullfile(mfilename,'keplerian6'));

% Semi-latus rectum
kep = State();
kep.semiLatusRectum = 3.5;
kep.eccentricity = 0.2;
kep.inclination = 0.3;
kep.argumentOfPeriapsis = 0.4;
kep.longitudeOfAscendingNode = 0.5;
kep.trueAnomaly = 0.6;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian7'));

% Eccentric anomaly
kep = State();
kep.semiMajorAxis = 3;
kep.eccentricity = 0.1;
kep.eccentricAnomaly = 1;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian8'));

% Mean anomaly
kep = State();
kep.semiMajorAxis = 3;
kep.eccentricity = 0.1;
kep.meanAnomaly = 1;
kep.centralBodyGravitationalParameter = mu;
test.createInput(kep,fullfile(mfilename,'keplerian9'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


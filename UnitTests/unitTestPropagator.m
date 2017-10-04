function [failCount,testOutput] = unitTestPropagator

tudat.load();


% Create input files for tests

% Test 1: propagator types
test.createInputForEnum(?IntegratedStates,fullfile(mfilename,'types'));

% Test 2: translational propagator types
test.createInputForEnum(?TranslationalPropagators,fullfile(mfilename,'translationalTypes'));

% Test 3: translational propagator
prp = TranslationalPropagator();
prp.type = TranslationalPropagators.encke;
prp.bodiesToPropagate = {'a','b'};
prp.centralBodies = {'A','B'};
prp.initialStates = 1:12;
prp.accelerations.a.A = {PointMassGravity()};
prp.accelerations.a.B = {PointMassGravity()};
prp.accelerations.b.A = {PointMassGravity()};
prp.accelerations.b.B = {PointMassGravity()};
test.createInput(prp,fullfile(mfilename,'translational'));

% Test 4: mass propagator
prp = MassPropagator();
prp.bodiesToPropagate = {'a','b'};
prp.initialStates = [100 200];
prp.massRateModels.a = {FromThrustMassRateModel()};
prp.massRateModels.b = {FromThrustMassRateModel()};
test.createInput(prp,fullfile(mfilename,'mass'));

% Test 5: rotational propagator
prp = RotationalPropagator();
prp.bodiesToPropagate = {'A','B'};
prp.initialStates = 0:13;
prp.torques.A.B = {SecondOrderGravitationalTorque()};
prp.torques.B.A = {SecondOrderGravitationalTorque(),AerodynamicTorque()};
test.createInput(prp,fullfile(mfilename,'rotational'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


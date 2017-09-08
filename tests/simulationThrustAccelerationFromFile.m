function [failcount,issueURL] = simulationThrustAccelerationFromFile

tudat.load();

% Simulation
simulation = Simulation(0,4e5,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
simulation.spice.preloadKernels = false;

% Bodies
vehicle = Body('vehicle');
vehicle.initialState.x = 8e6;
vehicle.initialState.vy = 7500;
vehicle.mass = 5000;
simulation.addBodies(Earth,vehicle);
simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(1,6));
simulation.bodies.Earth.ephemeris.frameOrientation = 'J2000';
simulation.bodies.Earth.gravityField.type = GravityFields.pointMassSpice;

% Gravitational accelerations
accelerationsOnVehicle.Earth = PointMassGravity();

% Thrust acceleration
thrust = Thrust();
thrust.dataInterpolation.data = FromFileDataMap('thrustValues.txt');
thrust.dataInterpolation.interpolator.type = Interpolators.linear;
thrust.specificImpulse = 3000;
thrust.frame = ThrustFrames.lvlh;
thrust.centralBody = Earth;
accelerationsOnVehicle.vehicle = thrust;

% Translational propagator
translationalPropagator = TranslationalPropagator();
translationalPropagator.centralBodies = Earth;
translationalPropagator.bodiesToPropagate = vehicle;
translationalPropagator.accelerations.vehicle = accelerationsOnVehicle;

% Mass propagator
massPropagator = MassPropagator();
massPropagator.bodiesToPropagate = vehicle;
massPropagator.massRateModels.vehicle = FromThrustMassRateModel();

% Hybrid propagator
simulation.propagators = {translationalPropagator, massPropagator};

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 30;

% Dependent variables
simulation.addResultsToSave('thrust','vehicle.acceleration@thrust-vehicle');
simulation.addResultsToSave('rotation','vehicle.lvlhToInertialFrameRotation-Earth');

% Generate input file
test.createInput(simulation,fullfile(mfilename,'main'));

% Run test
[failcount,issueURL] = test.runUnitTest(mfilename);


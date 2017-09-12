function [failcount,issueURL] = simulationThrustAlongVelocityVector

tudat.load();

% Simulation
simulation = Simulation(0,3600);
simulation.spice.preloadKernels = false;

% Bodies
vehicle = Body('vehicle');
vehicle.initialState.x = 8e6;
vehicle.initialState.vy = 7500;
vehicle.mass = 5000;
simulation.addBodies(Sun,Earth,Moon,vehicle);

% Gravitational accelerations
accelerationsOnVehicle.Earth = PointMassGravity();
accelerationsOnVehicle.Sun = PointMassGravity();
accelerationsOnVehicle.Moon = PointMassGravity();

% Thrust acceleration
thrust = Thrust();
thrust.direction.type = ThrustDirections.colinearWithStateSegment;
thrust.direction.relativeBody = Earth;
thrust.direction.colinearWithVelocity = true;
thrust.direction.towardsRelativeBody = false;
thrust.magnitude = ConstantThrustMagnitude();
thrust.magnitude.constantMagnitude = 25;
thrust.magnitude.specificImpulse = 5000;
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

% Generate input file
test.createInput(simulation,fullfile(mfilename,'main'));

% Run test
[failcount,issueURL] = test.runUnitTest(mfilename);


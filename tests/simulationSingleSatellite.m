function failcount = simulationSingleSatellite

tudat.load();

% Simulation
simulation = Simulation(0,constants.secondsInOne.julianDay);
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.cartesianState = convert.keplerianToCartesian([7500e3 0.1 deg2rad([85.3 235.7 23.4 139.87])]);
simulation.addBodies(Earth,asterix);
simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(6,1));

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = asterix;
propagator.accelerations.asterix.Earth = PointMassGravity();
simulation.propagator = propagator;

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 10;

% Generate input file
test.createInput(simulation,mfilename);


% Run test

failcount = test.runUnitTest(mfilename);



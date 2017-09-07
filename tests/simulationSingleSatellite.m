function failcount = simulationSingleSatellite

tudat.load();

% Simulation
simulation = Simulation(0,convert.toSI(1,'d'));
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = 7500e3;
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = 1.4888;
asterix.initialState.argumentOfPeriapsis = 4.1137;
asterix.initialState.longitudeOfAscendingNode = 0.4084;
asterix.initialState.trueAnomaly = 2.4412;
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


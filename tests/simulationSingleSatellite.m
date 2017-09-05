function failcount = simulationSingleSatellite

tudat.load();

% Simulation
simulation = Simulation(0,constants.secondsInOne.julianDay);
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = '7500 km';
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = '85.3 deg';
asterix.initialState.argumentOfPeriapsis = '235.7 deg';
asterix.initialState.longitudeOfAscendingNode = '23.4 deg';
asterix.initialState.trueAnomaly = '139.87 deg';
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



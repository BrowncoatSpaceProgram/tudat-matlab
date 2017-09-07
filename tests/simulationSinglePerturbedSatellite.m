function failcount = simulationSinglePerturbedSatellite

tudat.load();

% Simulation
simulation = Simulation(0,3600,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = 7500e3;
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = 1.4888;
asterix.initialState.argumentOfPeriapsis = 4.1137;
asterix.initialState.longitudeOfAscendingNode = 0.4084;
asterix.initialState.trueAnomaly = 2.4412;
asterix.mass = 400;
asterix.referenceArea = 4;
asterix.dragCoefficient = 1.2;
asterix.radiationPressureCoefficient = 1.2;
asterix.radiationPressure.Sun.occultingBodies = Earth;
simulation.addBodies(Sun,Earth,Moon,Mars,Venus,asterix);

% Accelerations
accelerationsOnAsterix.Earth = {SphericalHarmonicGravity(5,5), AerodynamicAcceleration()};
accelerationsOnAsterix.Sun = {PointMassGravity(), RadiationPressureAcceleration()};
accelerationsOnAsterix.Moon = PointMassGravity();
accelerationsOnAsterix.Mars = PointMassGravity();
accelerationsOnAsterix.Venus = PointMassGravity();

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = asterix;
propagator.accelerations.asterix = accelerationsOnAsterix;
simulation.propagator = propagator;

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 10;

% Generate input file
test.createInput(simulation,fullfile(mfilename,'main'));

% Run test
failcount = test.runUnitTest(mfilename);


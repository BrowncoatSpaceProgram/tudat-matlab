function failcount = simulationGalileoConstellation

tudat.load();

% Simulation
simulation = Simulation(0,convert.toSI(1,'d'),'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Satellites
numberOfSatellites = 30;
numberOfPlanes = 3;
numberOfSatellitesPerPlane = numberOfSatellites/numberOfPlanes;
for i = 1:numberOfSatellites
    simulation.addBodies(Body(sprintf('Satellite%i',i)));
end
satelliteNames = fieldnames(simulation.bodies);

% Celestial bodies
simulation.addBodies(Earth);
simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(6,1));
simulation.bodies.Earth.ephemeris.frameOrientation = 'J2000';

% Initial states
raans = mod(floor(((1:numberOfSatellites)-1)/numberOfSatellitesPerPlane),numberOfPlanes)*2*pi/numberOfPlanes;
trueAnomalies = mod((1:numberOfSatellites)-1,numberOfSatellitesPerPlane)*2*pi/numberOfSatellitesPerPlane;
for i = 1:numberOfSatellites
    satellite = simulation.bodies.(satelliteNames{i});
    satellite.initialState.semiMajorAxis = 23222e3 + 6378.1e3;
    satellite.initialState.inclination = deg2rad(56);
    satellite.initialState.longitudeOfAscendingNode = raans(i);
    satellite.initialState.trueAnomaly = trueAnomalies(i);
end

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = repmat({'Earth'},1,numberOfSatellites);
propagator.bodiesToPropagate = satelliteNames;
for i = 1:numberOfSatellites
    propagator.accelerations.(satelliteNames{i}).Earth = SphericalHarmonicGravity(4,0);
end
simulation.propagator = propagator;

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 30;

% Generate input file
test.createInput(simulation,fullfile(mfilename,'main'));

% Run test
failcount = test.runUnitTest(mfilename);


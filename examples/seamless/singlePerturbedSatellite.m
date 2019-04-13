%% Perturbed Earth-orbiting Satellite altered for Project 4

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation();
simulation.initialEpoch = 0;
simulation.finalEpoch = convert.toSI(1,'d');
simulation.globalFrameOrientation = 'J2000';

% Bodies - Altered with correct initial element values
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = 7686.489e3;
asterix.initialState.eccentricity = 0.1175;
asterix.initialState.inclination = deg2rad(2.2);
asterix.initialState.argumentOfPeriapsis = deg2rad(129.1);
asterix.initialState.longitudeOfAscendingNode = deg2rad(230.8);
asterix.initialState.trueAnomaly = deg2rad(0.91229);
simulation.addBodies(Earth,asterix);

% Accelerations - extra bodies and accelerations removed, leaving non-uniform gravity force
accelerationsOnAsterix.Earth = {SphericalHarmonicGravity(5,5)};

% Propagator
propagator = TranslationalPropagator();
propagator.bodiesToPropagate = {asterix};
propagator.centralBodies = {Earth};
propagator.accelerations.asterix = accelerationsOnAsterix;
simulation.propagators = {propagator};

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 10;

%% RUN

simulation.run();
% simulation.fullSettings


%% RESULTS

% Plot distance to Earth's CoM - Altered to simply compare initial and final position and velocity vectors
t = simulation.results.numericalSolution(:,1);
r = simulation.results.numericalSolution(:,2:4);
plot(convert.epochToDate(t),r/1e3);
grid on;
ylabel('Distance [km]');
legend('x','y','z','Location','South','Orientation','Horizontal');


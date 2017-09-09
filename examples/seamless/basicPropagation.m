%% Unperturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation();
simulation.initialEpoch = convert.dateToEpoch('1992-02-14 06:00');
simulation.finalEpoch = convert.dateToEpoch('1992-02-14 12:00');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = 7500e3;
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = deg2rad(5);
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


%% RUN

simulation.run();
% simulation.fullSettings


%% RESULTS

% Plot distance to Earth's CoM
t = simulation.results.numericalSolution(:,1);
r = simulation.results.numericalSolution(:,2:4);
plot(convert.epochToDate(t),r/1e3);
grid on;
ylabel('Distance [km]');
legend('x','y','z','Location','South','Orientation','Horizontal');


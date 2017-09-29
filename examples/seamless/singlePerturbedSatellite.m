%% Perturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation();
simulation.initialEpoch = 0;
simulation.finalEpoch = convert.toSI(1,'d');
simulation.globalFrameOrientation = 'J2000';

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = 7500e3;
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = deg2rad(85.3);
asterix.initialState.argumentOfPeriapsis = deg2rad(235.7);
asterix.initialState.longitudeOfAscendingNode = deg2rad(23.4);
asterix.initialState.trueAnomaly = deg2rad(139.87);
asterix.mass = 400;
asterix.referenceArea = 4;
asterix.dragCoefficient = 1.2;
asterix.radiationPressureCoefficient = 1.2;
asterix.radiationPressure.Sun.occultingBodies = {Earth};
simulation.addBodies(Sun,Earth,Moon,Mars,Venus,asterix);

% Accelerations
accelerationsOnAsterix.Earth = {SphericalHarmonicGravity(5,5), AerodynamicAcceleration()};
accelerationsOnAsterix.Sun = {PointMassGravity(), RadiationPressureAcceleration()};
accelerationsOnAsterix.Moon = {PointMassGravity()};
accelerationsOnAsterix.Mars = {PointMassGravity()};
accelerationsOnAsterix.Venus = {PointMassGravity()};

% Propagator
propagator = TranslationalPropagator();
propagator.bodiesToPropagate = {asterix};
propagator.centralBodies = {Earth};
propagator.accelerations.asterix = accelerationsOnAsterix;
simulation.propagators = {propagator};

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 10;

% Variables to save
% simulation.results.t and simulation.results.h will be set after calling simulation.run()
simulation.addResultsToSave('t','independent');  % independent variable (time in seconds since J2000)
simulation.addResultsToSave('h','asterix.altitude-Earth');  % altitude of Asterix wrt Earth


%% RUN

simulation.run();


%% RESULTS

% Plot altitude
figure;
plot(convert.epochToDate(simulation.results.t),simulation.results.h/1e3);
grid on;
ylabel('Altitude [km]');


%% RE-RUN SIMULATION FOR A SOLAR SAIL

asterix.mass = 4;
asterix.referenceArea = 40;
simulation.run();


%% ADD TO PLOT

hold on;
plot(convert.epochToDate(simulation.results.t),simulation.results.h/1e3);
hold off;
legend('Satellite','Solar sail','Location','South','Orientation','Horizontal');


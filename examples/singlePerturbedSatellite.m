%% Perturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

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


%% RUN

simulation.run();


%% RESULTS

% Plot altitude
[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
figure;
plot(convert.epochToDate(t),compute.altitude(r)/1e3);
grid on;
ylabel('Altitude [km]');


%% RE-RUN SIMULATION FOR A SOLAR SAIL

asterix.mass = 4;
asterix.referenceArea = 40;
simulation.run();


%% ADD TO PLOT

[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
hold on;
plot(convert.epochToDate(t),compute.altitude(r)/1e3);
hold off;
legend('asterix stellite','Solar sail','Location','NorthWest');


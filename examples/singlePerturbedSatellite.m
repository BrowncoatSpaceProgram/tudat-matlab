%% Perturbed Earth-orbiting Satellite

clc; clear all;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
satellite = Body('Asterix');
satellite.mass = 400;
satellite.referenceArea = 4;
satellite.dragCoefficient = 1.2;
satellite.radiationPressureCoefficient = 1.2;
satellite.radiationPressure.Sun.occultingBodies = { 'Earth' };
simulation.addBodies('Sun','Earth','Moon','Mars','Venus',satellite);

% Accelerations
accelerationsOfAsterix.Earth = { SphericalHarmonicGravity(5,5), AerodynamicAcceleration() };
accelerationsOfAsterix.Sun = { PointMassGravity(), RadiationPressureAcceleration() };
accelerationsOfAsterix.Moon = PointMassGravity();
accelerationsOfAsterix.Mars = PointMassGravity();
accelerationsOfAsterix.Venus = PointMassGravity();

% Propagator
propagator = TranslationalPropagator();
initialKeplerianState = [7500.0E3 0.1 deg2rad(85.3) deg2rad(235.7) deg2rad(23.4) deg2rad(139.87)];
propagator.initialStates = convert.keplerianToCartesian(initialKeplerianState);
propagator.centralBodies = 'Earth';
propagator.bodiesToPropagate = 'Asterix';
propagator.accelerations.Asterix = accelerationsOfAsterix;
simulation.propagator = propagator;

% Integrator
simulation.integrator = Integrator(Integrators.rungeKutta4,10);


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

satellite.mass = 4;
satellite.referenceArea = 40;
simulation.run();


%% ADD TO PLOT

[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
hold on;
plot(convert.epochToDate(t),compute.altitude(r)/1e3);
hold off;
legend('Asterix stellite','Solar sail','Location','NorthWest');


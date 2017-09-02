%% Perturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.cartesianState = convert.keplerianToCartesian([7500.0E3 0.1 deg2rad([85.3 235.7 23.4 139.87])]);
asterix.mass = 400;
asterix.referenceArea = 4;
asterix.dragCoefficient = 1.2;
asterix.radiationPressureCoefficient = 1.2;
asterix.radiationPressure.Sun.occultingBodies = 'Earth';
simulation.addBodies(Sun,Earth,Moon,Mars,Venus,asterix);

% Accelerations
accelerationsOfasterix.Earth = {SphericalHarmonicGravity(5,5), AerodynamicAcceleration()};
accelerationsOfasterix.Sun = {PointMassGravity(), RadiationPressureAcceleration()};
accelerationsOfasterix.Moon = PointMassGravity();
accelerationsOfasterix.Mars = PointMassGravity();
accelerationsOfasterix.Venus = PointMassGravity();

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = 'Earth';
propagator.bodiesToPropagate = asterix;
propagator.accelerations.asterix = accelerationsOfasterix;
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


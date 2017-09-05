%% Perturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = '7500 km';
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = '85.3 deg';
asterix.initialState.argumentOfPeriapsis = '235.7 deg';
asterix.initialState.longitudeOfAscendingNode = '23.4 deg';
asterix.initialState.trueAnomaly = '139.87 deg';
asterix.mass = 400;
asterix.referenceArea = 4;
asterix.dragCoefficient = 1.2;
asterix.radiationPressureCoefficient = 1.2;
asterix.radiationPressure.Sun.occultingBodies = 'Earth';
simulation.addBodies(Sun,Earth,Moon,Mars,Venus,asterix);

% Accelerations
accelerationsOnasterix.Earth = {SphericalHarmonicGravity(5,5), AerodynamicAcceleration()};
accelerationsOnasterix.Sun = {PointMassGravity(), RadiationPressureAcceleration()};
accelerationsOnasterix.Moon = PointMassGravity();
accelerationsOnasterix.Mars = PointMassGravity();
accelerationsOnasterix.Venus = PointMassGravity();

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = 'Earth';
propagator.bodiesToPropagate = asterix;
propagator.accelerations.asterix = accelerationsOnasterix;
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


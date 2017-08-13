%% Perturbed Earth-orbiting Satellite

clc; clear variables;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('Asterix');
asterix.mass = 400;
asterix.referenceArea = 4;
asterix.dragCoefficient = 1.2;
asterix.radiationPressureCoefficient = 1.2;
asterix.radiationPressure.Sun.occultingBodies = { 'Earth' };
simulation.addBodies('Sun','Earth','Moon','Mars','Venus',asterix);

% Accelerations
accelerationsOfAsterix.Earth = { SphericalHarmonicGravity(5,5), AerodynamicAcceleration() };
accelerationsOfAsterix.Sun = { PointMassGravity(), RadiationPressureAcceleration() };
accelerationsOfAsterix.Moon = { PointMassGravity() };
accelerationsOfAsterix.Mars = { PointMassGravity() };
accelerationsOfAsterix.Venus = { PointMassGravity() };

% Propagator
propagator = TranslationalPropagator();
initialKeplerianState = [7500.0E3 0.1 deg2rad(85.3) deg2rad(235.7) deg2rad(23.4) deg2rad(139.87)];
propagator.initialState = convert.keplerianToCartesian(initialKeplerianState);
propagator.centralBody = 'Earth';
propagator.bodyToPropagate = 'Asterix';
propagator.accelerations.Asterix = accelerationsOfAsterix;
simulation.propagation = propagator;

% Integrator
simulation.integrator = Integrator(Integrators.rungeKutta4,10);


%% RUN

simulation.run();


%% RESULTS

% Plot Keplerian components history
plot.keplerianComponentsHistory(simulation.results.numericalSolution);

% Plot altitude
[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
figure; plot(convert.epochToDate(t),compute.altitude(r)/1e3); grid on; ylabel('Altitude [km]');


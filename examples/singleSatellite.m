%% Unperturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay);
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
earth = Body('Earth');
earth.useDefaultSettings = true;
earth.ephemeris = ConstantEphemeris(zeros(6,1));
simulation.addBodies(earth,Body('Asterix'));

% Propagator
propagator = TranslationalPropagator();
initialKeplerianState = [7500.0E3 0.1 deg2rad(85.3) deg2rad(235.7) deg2rad(23.4) deg2rad(139.87)];
propagator.initialStates = convert.keplerianToCartesian(initialKeplerianState);
propagator.centralBodies = 'Earth';
propagator.bodiesToPropagate = 'Asterix';
propagator.accelerations.Asterix.Earth = PointMassGravity();
simulation.propagator = propagator;

% Integrator
simulation.integrator = Integrator(Integrators.rungeKutta4,10);


%% RUN

simulation.run();


%% RESULTS

% Plot distance to Earth's CoM
[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
plot(convert.epochToDate(t),compute.normPerRows(r)/1e3); grid on; ylabel('Distance [km]');

% Unperturbed orbit: check that the Keplerian elements stay constant
[~,a,e,i,omega,raan,~] = compute.epochKeplerianElements(simulation.results.numericalSolution);
tolerance = 1e-7;
[all(abs(a-a(1)) < tolerance*a(1)) all(abs(e-e(1)) < tolerance) all(abs(i-i(1)) < tolerance) ...
    all(abs(omega-omega(1)) < tolerance) all(abs(raan-raan(1)) < tolerance)]


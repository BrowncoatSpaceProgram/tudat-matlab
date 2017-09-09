%% Un-guided Capsule Entry

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,3100,'SSB','J2000');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
earth = Body('Earth');
earth.useDefaultSettings = true;
earth.ephemeris = ConstantEphemeris(zeros(6,1));
apollo = Body('Apollo');
apollo.mass = 5e3;
apolloCoefficientInterface = [];
apollo.aerodynamics = apolloCoefficientInterface;
simulation.addBodies(earth,apollo);

% Propagator
propagator = TranslationalPropagator();
initialSphericalState = [7500.0E3 0.1 deg2rad([85.3 235.7 23.4 139.87])];
propagator.initialState = convert.sphericalToCartesian(initialSphericalState);
propagator.centralBody = 'Earth';
propagator.bodyToPropagate = 'Apollo';
propagator.accelerations.Apollo.Earth = { SphericalHarmonicGravity(4,0), AerodynamicAcceleration() };
simulation.propagation = propagator;

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


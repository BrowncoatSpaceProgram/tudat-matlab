%% User-defined Thrust Vector

clc; clear;
tudat.load();


%% SET UP

% Create Simulation object with Spice
simulation = Simulation(0,convert.toSI(14,'d'));
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
simulation.spice.preloadKernels = false;

% Bodies
vehicle = Body('vehicle');
vehicle.cartesianState = [8e6 0 0 0 7.5e3 0];
vehicle.mass = 5e3;
simulation.addBodies(Sun,Earth,Moon,vehicle);

% Gravitational accelerations
accelerationsOfVehicle.Earth = PointMassGravity();
accelerationsOfVehicle.Sun = PointMassGravity();
accelerationsOfVehicle.Moon = PointMassGravity();

% Thrust acceleration
thrust = Thrust();
thrust.dataInterpolation.data = FromFileDataMap('thrustValues.txt');
thrust.dataInterpolation.interpolator.type = Interpolators.linear;
thrust.specificImpulse = 3000;
thrust.frame = ThrustFrames.lvlh;
thrust.centralBody = Earth;
accelerationsOfVehicle.vehicle = thrust;

% Translational propagator
translationalPropagator = TranslationalPropagator();
translationalPropagator.centralBodies = Earth;
translationalPropagator.bodiesToPropagate = vehicle;
translationalPropagator.accelerations.vehicle = accelerationsOfVehicle;

% Mass propagator
massPropagator = MassPropagator();
massPropagator.bodiesToPropagate = vehicle;
massPropagator.massRateModels.vehicle = FromThrustMassRateModel();

% Hybrid propagator
simulation.propagators = {translationalPropagator, massPropagator};

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 30;


%% RUN

simulation.run();


%% RESULTS

[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
dates = convert.epochToDate(t);
h = compute.altitude(r);
figure;
grid on;

yyaxis left;
semilogy(dates,h/1e3);
ylabel('Altitude [km]');
hold on;

m = simulation.results.numericalSolution(:,end);
yyaxis right;
plot(dates,m);
ylabel('Mass [kg]');

fprintf('Final mass: %g kg\n',m(end));


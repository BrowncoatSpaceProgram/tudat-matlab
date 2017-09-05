%% Thrust Force Along Velocity Vector

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,convert.toSI(14,'d'));
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
simulation.spice.preloadKernels = false;

% Bodies
vehicle = Body('vehicle');
vehicle.initialState.x = '8000 km';
vehicle.initialState.vy = '7.5 km/s';
vehicle.mass = 5000;
simulation.addBodies(Sun,Earth,Moon,vehicle);

% Gravitational accelerations
accelerationsOnVehicle.Earth = PointMassGravity();
accelerationsOnVehicle.Sun = PointMassGravity();
accelerationsOnVehicle.Moon = PointMassGravity();

% Thrust acceleration
thrust = Thrust();
thrust.direction.type = ThrustDirections.colinearWithStateSegment;
thrust.direction.relativeBody = Earth;
thrust.direction.colinearWithVelocity = true;
thrust.direction.towardsRelativeBody = false;
thrust.magnitude = ConstantThrustMagnitude();
thrust.magnitude.constantMagnitude = 25;
thrust.magnitude.specificImpulse = 5000;
accelerationsOnVehicle.vehicle = thrust;

% Translational propagator
translationalPropagator = TranslationalPropagator();
translationalPropagator.centralBodies = Earth;
translationalPropagator.bodiesToPropagate = vehicle;
translationalPropagator.accelerations.vehicle = accelerationsOnVehicle;

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

% With thrust
simulation.run();
thrustResults = simulation.results.numericalSolution;

% Without thrust
thrust.magnitude.constantMagnitude = 0;
simulation.run();
noThrustResults = simulation.results.numericalSolution;


%% RESULTS

[t,r,~] = compute.epochPositionVelocity(noThrustResults);
dates = convert.epochToDate(t);
h = compute.altitude(r);
figure;
grid on;

yyaxis left;
semilogy(dates,h/1e3);
ylabel('Altitude [km]');
hold on;

[t,r,~] = compute.epochPositionVelocity(thrustResults);
dates = convert.epochToDate(t);
h = compute.altitude(r);
semilogy(dates,h/1e3);
legend('No thrust','Constant thrust','Location','NorthWest');
hold off;

m = thrustResults(:,end);
yyaxis right;
plot(dates,m);
ylabel('Mass [kg]');

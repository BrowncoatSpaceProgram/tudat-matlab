%% Thrust Force Along Velocity Vector

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,convert.toSI(14,'d'));
simulation.spice.preloadKernels = false;

% Bodies
vehicle = Body('vehicle');
vehicle.initialState.x = 8e6;
vehicle.initialState.vy = 7500;
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
epochsOn = simulation.results.numericalSolution(:,1);
statesOn = simulation.results.numericalSolution(:,2:7);
masses = simulation.results.numericalSolution(:,8);

% Without thrust
thrust.magnitude.constantMagnitude = 0;
simulation.run();
epochsOff = simulation.results.numericalSolution(:,1);
statesOff = simulation.results.numericalSolution(:,2:7);


%% RESULTS

figure;
grid on;

yyaxis left;
altitudesOff = compute.altitude(statesOff,Earth);  % use Earth's average radius
semilogy(convert.epochToDate(epochsOff),altitudesOff/1e3);
ylabel('Altitude [km]');
hold on;

altitudesOn = compute.altitude(statesOn,Earth);
semilogy(convert.epochToDate(epochsOn),altitudesOn/1e3);
legend('No thrust','Constant thrust','Location','NorthWest');
hold off;

yyaxis right;
plot(convert.epochToDate(epochsOn),masses);
ylabel('Mass [kg]');


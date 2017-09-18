%% User-defined Thrust Vector

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,4e5);
simulation.spice.preloadEphemeris = false;

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
thrust.dataInterpolation.data = FromFileDataMap('thrustValues.txt');
thrust.dataInterpolation.interpolator.type = Interpolators.linear;
thrust.specificImpulse = 3000;
thrust.frame = ThrustFrames.lvlh;
thrust.centralBody = Earth;
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

% Save variables
% Thrust acceleration on vehicle by vehicle
simulation.addResultsToSave('thrust','vehicle.acceleration@thrust-vehicle');
% lvlh to inertial frame rotation of vehicle wrt Earth
simulation.addResultsToSave('rotation','vehicle.lvlhToInertialFrameRotation-Earth');


%% RUN

simulation.run();


%% RESULTS

dates = convert.epochToDate(simulation.results.numericalSolution(:,1));
h = compute.altitude(simulation.results.numericalSolution(:,2:7),Earth);  % use Earth's average radius
figure;
grid on;

yyaxis left;
semilogy(dates,h/1e3);
ylabel('Altitude [km]');
hold on;

m = simulation.results.numericalSolution(:,8);
yyaxis right;
plot(dates,m);
ylabel('Mass [kg]');

fprintf('Final mass: %g kg\n',m(end));

figure;
plot(dates,simulation.results.thrust);
ylabel('Thrust [m/s^2]');
legend('x','y','z');
grid on;

disp('Final lvlh to inertial frame rotation matrix:');
disp(reshape(simulation.results.rotation(end,:),3,3));


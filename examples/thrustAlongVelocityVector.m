%% Thrust Force Along Velocity Vector

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,convert.toSI(14,'d'));
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
simulation.spice.preloadKernels = false;

% Bodies
vehicle = Body('Vehicle');
vehicle.mass = 5e3;
simulation.addBodies('Sun','Earth','Moon',vehicle);

% Gravitational accelerations
accelerationsOfVehicle.Earth = PointMassGravity();
accelerationsOfVehicle.Sun = PointMassGravity();
accelerationsOfVehicle.Moon = PointMassGravity();

% Thrust acceleration
thrustDirection = ThrustDirection(ThrustDirections.colinearWithStateSegment);
thrustDirection.relativeBody = 'Earth';
thrustDirection.colinearWithVelocity = true;
thrustDirection.towardsRelativeBody = false;
thrust = Thrust();
thrust.direction = thrustDirection;
thrust.magnitude = ConstantThrustMagnitude(25,5000);
accelerationsOfVehicle.Vehicle = thrust;

% Translational propagator
translationalPropagator = TranslationalPropagator();
translationalPropagator.centralBodies = 'Earth';
translationalPropagator.bodiesToPropagate = 'Vehicle';
translationalPropagator.initialStates = [8e6 0 0 0 7.5e3 0];
translationalPropagator.accelerations.Vehicle = accelerationsOfVehicle;

% Mass propagator
massPropagator = MassPropagator();
massPropagator.bodiesToPropagate = 'Vehicle';
massPropagator.initialStates = vehicle.mass;
massPropagator.massRateModels.Vehicle = FromThrustMassRateModel();

% Hybrid propagator
simulation.propagators = { translationalPropagator, massPropagator };

% Integrator
simulation.integrator = Integrator(Integrators.rungeKutta4,30);


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

%% User-defined Thrust Vector

clc; clear;
tudat.load();


%% SET UP

% Create Simulation object with Spice
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
thrust.dataInterpolation.data = FromFileDataMap('thrustValues.txt');
thrust.dataInterpolation.interpolator.type = 'linear';
thrust.specificImpulse = 3000;
thrust.frame = 'lvlh';
thrust.centralBody = 'Earth';
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
simulation.propagator = { translationalPropagator, massPropagator };

% Integrator
simulation.integrator = Integrator(Integrators.rungeKutta4,30);


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


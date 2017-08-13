%% Thrust Force Along Velocity Vector

clc; clear variables;
tudat.load();


%% SET UP

simulation = Simulation(0,convert.toSI(14,'d'),'SSB','ECLIPJ2000');
spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
spice.preloadKernels = false;
simulation.spice = spice;

% Bodies
vehicle = Body('Vehicle');
vehicle.mass = 5e3;
simulation.addBodies('Sun','Earth','Moon',vehicle);

% Gravitational accelerations
accelerationsOfVehicle.Earth = { PointMassGravity() };
accelerationsOfVehicle.Sun = { PointMassGravity() };
accelerationsOfVehicle.Moon = { PointMassGravity() };

% Thrust acceleration
thrustDirection = ThrustDirection(ThrustDirections.colinearWithStateSegment);
thrustDirection.relativeBody = 'Earth';
thrustDirection.colinearWithVelocity = true;
thrustDirection.towardsRelativeBody = false;
thrust = Thrust(thrustDirection,ConstantThrustMagnitude(25,5000));
accelerationsOfVehicle.Vehicle = { thrust };

% Translational propagator
translationalPropagator = TranslationalPropagator();
translationalPropagator.centralBody = 'Earth';
translationalPropagator.bodyToPropagate = 'Vehicle';
translationalPropagator.initialState = [8e6 0 0 7.5e3 0 0];
translationalPropagator.accelerations.Vehicle = accelerationsOfVehicle;

% Mass propagator
massPropagator = MassPropagator();
massPropagator.bodyToPropagate = 'Vehicle';
massPropagator.initialState = vehicle.mass;
massPropagator.massRates.Vehicle = { MassRate(thrust) };

% Hybrid propagator
simulation.propagation = HybridPropagator(translationalPropagator,massPropagator);

% Integrator
simulation.integrator = Integrator(Integrators.rungeKutta4,30);


%% RUN

simulation.run();


%% RESULTS

simulation.results.numericalSolution


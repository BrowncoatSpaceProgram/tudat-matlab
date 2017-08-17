% For code comments, see: https://github.com/aleixpinardell/tudat-matlab#usage

tudat.load();

simulation = Simulation('1992-02-14 06:00','1992-02-14 12:00');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
satelliteBody = Body('Satellite');
simulation.addBodies('Earth',satelliteBody);
propagator = TranslationalPropagator();
initialKeplerianState = [7500.0E3 0.1 deg2rad(5) 0 0 0];
propagator.initialStates = convert.keplerianToCartesian(initialKeplerianState);
propagator.centralBodies = 'Earth';
propagator.bodiesToPropagate = 'Satellite';
propagator.accelerations.Satellite.Earth = PointMassGravity();
simulation.propagator = propagator;
simulation.integrator = Integrator(Integrators.rungeKutta4,20);

simulation.run();

[t,r,v] = compute.epochPositionVelocity(simulation.results.numericalSolution);
plot(convert.epochToDate(t),r/13);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;

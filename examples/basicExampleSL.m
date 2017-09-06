% For code comments, see: https://github.com/aleixpinardell/tudat-matlab#usage

clc; clear;
tudat.load();

simulation = Simulation('1992-02-14 06:00','1992-02-14 12:00');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
satellite = Body('satellite');
satellite.initialState.semiMajorAxis = 7500e3;
satellite.initialState.eccentricity = 0.1;
satellite.initialState.inclination = deg2rad(5);
simulation.addBodies(Earth,satellite);
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = satellite;
propagator.accelerations.satellite.Earth = PointMassGravity();
simulation.propagator = propagator;
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 20;

simulation.run();

[t,r,v] = compute.epochPositionVelocity(simulation.results.numericalSolution);
plot(convert.epochToDate(t),r/13);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;

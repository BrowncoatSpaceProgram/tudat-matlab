% For code comments, see: https://github.com/aleixpinardell/tudat-matlab#usage

clc; clear;
tudat.load();

simulation = Simulation();
simulation.initialEpoch = convert.dateToEpoch('1992-02-14 06:00');
simulation.finalEpoch = convert.dateToEpoch('1992-02-14 12:00');
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
disp(simulation.fullSettings);

t = simulation.results.numericalSolution(:,1);
r = simulation.results.numericalSolution(:,2:4);
plot(convert.epochToDate(t),r/1e3);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;


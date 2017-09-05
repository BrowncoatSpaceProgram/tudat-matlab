% For code comments, see: https://github.com/aleixpinardell/tudat-matlab#usage

%% Create input file
clc; clear;
tudat.load();

simulation = Simulation('1992-02-14 06:00','1992-02-14 12:00');
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
satellite = Body('satellite');
satellite.initialState.semiMajorAxis = '7500 km';
satellite.initialState.eccentricity = 0.1;
satellite.initialState.inclination = '5 deg';
simulation.addBodies(Earth,satellite);
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = satellite;
propagator.accelerations.satellite.Earth = PointMassGravity();
simulation.propagator = propagator;
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 20;
simulation.addResultsToExport('results.txt',{'independent','state'});
simulation.options.populatedFile = 'unperturbedSatellite-populated.json';

json.export(simulation,'unperturbedSatellite.json');

%% Run "tudat unperturbedSatellite.json" from the command-line

%% Use output
[results,failed] = loadResults('results.txt');
if failed
    warning('Propagation failed: plotting results obtained until propagation failure.');
end
t = results(:,1);
r = results(:,2:4);
plot(convert.epochToDate(t),r/13);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;

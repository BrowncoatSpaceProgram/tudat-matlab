%% Multiple propagations

clc; clear variables;
tudat.load();


%% SET UP

% Simulation
simulation = Simulation(0);
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');
simulation.spice.preloadKernels = false;

% Bodies
satellite = Body('satellite');
satellite.initialState.apoapsisAltitude = 300e3;
satellite.initialState.periapsisAltitude = 200e3;
satellite.initialState.inclination = deg2rad(60);
satellite.initialState.trueAnomaly = deg2rad(45);
satellite.dragCoefficient = 2.5;
satellite.radiationPressureCoefficient = 1.2;
satellite.radiationPressure.Sun.occultingBodies = Earth;
simulation.addBodies(Earth,Sun,Moon,Mars,Venus,satellite);

% Accelerations
accelerationsOnSatellite.Earth = {SphericalHarmonicGravity(5,5), AerodynamicAcceleration()};
accelerationsOnSatellite.Sun = {PointMassGravity(), RadiationPressureAcceleration()};
accelerationsOnSatellite.Moon = PointMassGravity();
accelerationsOnSatellite.Mars = PointMassGravity();
accelerationsOnSatellite.Venus = PointMassGravity();

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = satellite;
propagator.accelerations.satellite = accelerationsOnSatellite;
simulation.propagator = propagator;

% Termination
simulation.termination = Variable('satellite.periapsisAltitude-Earth') < 105e3;

% Integrator
integrator = VariableStepSizeIntegrator(RungeKuttaCoefficientSets.rungeKuttaFehlberg78);
integrator.initialStepSize = 20;
integrator.minimumStepSize = 5;
integrator.maximumStepSize = 1e4;
integrator.errorTolerance = 1e-11;
integrator.saveFrequency = 5;
simulation.integrator = integrator;


%% RUN

% Propagate multiple cases by changing the properties of any of the objects
% contained by the Simulation object
masses = 200:100:800;
referenceAreas = 8:-1:2;
results = cell(size(masses));
for i = 1:length(masses)
    fprintf('Running case %i of %i...\n',i,length(masses));
    satellite.mass = masses(i);
    satellite.referenceArea = referenceAreas(i);
    simulation.run();
    results{i} = simulation.results.numericalSolution;
end


%% RESULTS

figure;
plot.apoapsisPeriapsisAltitudesHistory(results,'CentralBody',Earth);
l = legend(sprintfc('%g',masses));
l.Title.String = 'Mass [kg]';


clc; clear variables;
tudat.load();

% Simulation
simulation = Simulation(0);
simulation.spice.preloadEphemeris = false;

% Bodies
satellite = Body('satellite');
satellite.initialState.altitude = 230e3;
satellite.initialState.inclination = deg2rad(60);
satellite.initialState.trueAnomaly = deg2rad(45);
satellite.dragCoefficient = 1.2;
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
altitude = Variable('satellite.altitude-Earth');
simulation.termination = altitude < 80e3;

% Integrator
integrator = VariableStepSizeIntegrator(RungeKuttaCoefficientSets.rungeKuttaFehlberg78);
integrator.initialStepSize = 20;
integrator.minimumStepSize = 5;
integrator.maximumStepSize = 1e4;
integrator.errorTolerance = 1e-11;
simulation.integrator = integrator;

% Define results to export (epoch, states and altitude)
% Path defined relative to the input file in which it is defined
% ${ROOT_FILE_STEM} will be replaced by the name (without extension) of the input file during run-time
simulation.addResultsToExport(fullfile('..','OUTPUT','${ROOT_FILE_STEM}.txt'),{'independent','state',altitude});

% Options
simulation.options.notifyOnPropagationTermination = true;

% Generate file containing the shared settings for all the propagations
json.export(simulation,fullfile('INPUT','shared.json'));

% Generate individual files for different satellite properties
masses = 200:100:800;
referenceAreas = 8:-1:2;
for i = 1:length(masses)
    m = masses(i);
    A = referenceAreas(i);
    
    % Define the path the file will be saved to
    filePath = fullfile('INPUT',sprintf('mass%i.json',m));
    
    % Create a JSON-formatted text by merging "shared.json" and the specific mass
    fileContents = json.merge('$(shared.json)','bodies.satellite.mass',m,'bodies.satellite.referenceArea',A);
    % The contents of "shared.json" are not included in fileContents,
    % but referenced by using $(), in order to prevent large file sizes
    % If you don't want to use a shared file, you can use json.merge(simulation,...)
    % or modify the simulation object in each iteration and then json.export(simulation,filePath)
    
    % Export the file
    json.export(fileContents,filePath);
end

% Don't include this part in your scripts
mdir = fileparts(mfilename('fullpath'));
fprintf('In Terminal, run:\n\n');
for i = 1:length(masses)
    fprintf('%s %s\n',tudat.binary,fullfile(mdir,'INPUT',sprintf('mass%i.json',masses(i))));
end
fprintf('\nor, if you have <a href="matlab: web(''https://www.gnu.org/software/parallel/'',''-browser'')">GNU Parallel</a> installed:\n\n')
fprintf('parallel %s ::: %s\n\n',tudat.binary,fullfile(mdir,'INPUT','mass*.json'));

% Unperturbed Earth-orbiting Satellite

clc; clear;
tudat.load();

% Simulation
simulation = Simulation();
simulation.initialEpoch = convert.dateToEpoch('1992-02-14 06:00');
simulation.finalEpoch = convert.dateToEpoch('1992-02-14 12:00');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = 7500e3;
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = deg2rad(5);
simulation.addBodies(Earth,asterix);
simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(6,1));

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = {Earth};
propagator.bodiesToPropagate = {asterix};
propagator.accelerations.asterix.Earth = {PointMassGravity()};
simulation.propagators = {propagator};

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 20;

% Path of the input file that will be generated and provided to Tudat
inputFile = fullfile('input','main.json');

% Define results to save (paths are defined relative to the input file)
simulation.addResultsToExport(fullfile('..','output','results.txt'),{'independent','state'});

% Ask to save the full settings (with default values) actually used by Tudat
% (again path is defined relative to the input file)
simulation.options.fullSettingsFile = 'fullSettings.json';

% Generate inpur file
json.export(simulation,inputFile);

% Don't include this part in your scripts
mdir = fileparts(mfilename('fullpath'));
fprintf('In Terminal, run any of these commands (all equivalent):\n\n');
fprintf('%s %s\n',tudat.binary,fullfile(mdir,'input'));
fprintf('%s %s\n',tudat.binary,fullfile(mdir,'input','main'));
fprintf('%s %s\n\n',tudat.binary,fullfile(mdir,'input','main.json'));


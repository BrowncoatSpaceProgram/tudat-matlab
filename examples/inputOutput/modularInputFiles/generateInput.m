clc; clear;
tudat.load();

% Create satellite body
satellite = Body('satellite');
satellite.initialState.periapsisAltitude = 200e3;
satellite.initialState.apoapsisAltitude = 36000e3;
satellite.initialState.inclination = deg2rad(10);
satellite.mass = 500;
satellite.referenceArea = 4;
satellite.dragCoefficient = 2.5;
satellite.radiationPressureCoefficient = 1.2;
satellite.radiationPressure.Sun.occultingBodies = {'Earth'};

% Create Earth body with custom properties (use NRLMSISE00 atmosphere model)
earth = Earth();
earth.atmosphere.type = AtmosphereModels.nrlmsise00;
earth.gravityField = SphericalHarmonicGravityField(SphericalHarmonicModels.ggm02c);

% Define Tudat variables
t = Variable('independent');
r = Variable('satellite.relativePosition-Earth');
v = Variable('satellite.relativeVelocity-Earth');

% Define accelerations acting on satellite caused by Earth, the Sun and the Moon
accelerationsOnSatellite.Earth = {SphericalHarmonicGravity(7,7), AerodynamicAcceleration()};
accelerationsOnSatellite.Sun = {PointMassGravity(), RadiationPressureAcceleration()};
accelerationsOnSatellite.Moon = {SphericalHarmonicGravity(4,4)};

% Define the propagator to use
propagator = TranslationalPropagator();
propagator.bodiesToPropagate = {satellite};
propagator.centralBodies = {Earth};
propagator.accelerations.satellite = accelerationsOnSatellite;

% Define the itegrator to use
integrator = Integrator();
integrator.type = Integrators.rungeKutta4;
integrator.stepSize = 30;

% Create directory in which to save the input files (if necessary) and change working directory
if exist('input','dir') ~= 7
    mkdir('input');
end
originalWorkingDirectory = cd;
cd('input');

% Create Simulation object
simulation = Simulation();
simulation.initialEpoch = convert.dateToEpoch('2015-02-14 07:30:00');
simulation.finalEpoch = convert.dateToEpoch('2015-02-19 08:00:00');
simulation.globalFrameOrigin = 'SSB';
simulation.globalFrameOrientation = 'J2000';

% Add bodies to simulation
simulation.addBodies(earth,Moon,Sun,satellite);

% Export simulation.bodies to a file called bodies.json, and define simulation.bodies to point to that file
simulation.bodies = json.modular(simulation.bodies,'bodies.json');

% Export propagator to a file called prop.json, and define simulation.propagator to point to that file
simulation.propagators = {json.modular(propagator,'translationalPropagator.json')};

% Export integrator to a file called rk4.json, and define simulation.integrator to point to that file
simulation.integrator = json.modular(integrator,'rk4.json');

% Define results to export
% Paths are relative to the main.json file directory
simulation.addResultsToExport(fullfile('..','output','epochs.txt'),t);
simulation.addResultsToExport(fullfile('..','output','states.txt'),{r,v});

% Export simulation.export to a file called export.json, and define simulation.export to point to that file
simulation.export = json.modular(simulation.export,'export.json');

% Define simulation options
simulation.options.fullSettingsFile = 'fullSettings.json';
simulation.options.printInterval = convert.toSI(1,'d');

% Export the simulation object to the main file
json.export(simulation,'main.json');

% Switch back to the original working directory
cd(originalWorkingDirectory);

% Don't include this part in your scripts
mdir = fileparts(mfilename('fullpath'));
fprintf('In Terminal, run any of these commands (all equivalent):\n\n');
fprintf('"%s" "%s"\n',tudat.binary,fullfile(mdir,'input'));
fprintf('"%s" "%s"\n',tudat.binary,fullfile(mdir,'input','main'));
fprintf('"%s" "%s"\n\n',tudat.binary,fullfile(mdir,'input','main.json'));


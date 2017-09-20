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
satellite.radiationPressure.Sun.occultingBodies = 'Earth';

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
accelerationsOnSatellite.Moon = SphericalHarmonicGravity(4,4);

% Define the propagator to use
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = satellite;
propagator.accelerations.satellite = accelerationsOnSatellite;

% Define the itegrator to use
integrator = Integrator();
integrator.type = Integrators.rungeKutta4;
integrator.stepSize = 30;

% Create directory in which to save the input files (if necessary) and change working directory
if exist('tmpin','dir') ~= 7
    mkdir('tmpin');
end
originalWorkingDirectory = cd;
cd('tmpin');

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
simulation.propagator = json.modular(propagator,'prop.json');

% Export integrator to a file called rk4.json, and define simulation.integrator to point to that file
simulation.integrator = json.modular(integrator,'rk4.json');

% Path of the main JSON file that will be provided as input to the tudat binary
% Recall that the working directory has been changed to /
mainFile = 'main.json';

% Define results to export
% Paths are relative to the main.json file directory
simulation.addResultsToExport(fullfile('..','tmpout','epochs.txt'),t);
simulation.addResultsToExport(fullfile('..','tmpout','states.txt'),{r,v});

% Export simulation.export to a file called export.json, and define simulation.export to point to that file
simulation.export = json.modular(simulation.export,'export.json');

% Define simulation options
simulation.options.fullSettingsFile = 'fullSettings.json';
simulation.options.printInterval = convert.toSI(1,'d');

% Export the simulation object to the main file
json.export(simulation,mainFile);

% Switch back to the original working directory
cd(originalWorkingDirectory);

% Don't include this part in your scripts
mdir = fileparts(mfilename('fullpath'));
fprintf('In Terminal, run any of these commands (all equivalent):\n\n');
fprintf('%s %s\n',tudat.binary,fullfile(mdir,'tmpin'));
fprintf('%s %s\n',tudat.binary,fullfile(mdir,'tmpin','main'));
fprintf('%s %s\n\n',tudat.binary,fullfile(mdir,'tmpin','main.json'));


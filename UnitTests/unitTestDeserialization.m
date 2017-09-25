function [failCount,testOutput] = unitTestDeserialization

tudat.load();


% Create input files for tests

% Test 1: value access

cat.type = 'cat';
cat.name = 'Skai';
cat.age = 8;
cat.mass = 2.6;
cat.offspring = {'Dee','Cout','Plaat'};
cat.offspringMasses = [1.7, 1.8, 1.3];
cat.mother.birthplace.city.name = 'Valencia';
cat.mother.birthplace.city.temperatureRange = [0, 40];
cat.mother.birthplace.continent.name = 'Europe';
cat.mother.birthplace.continent.temperatureRange = [-15, 45];

dog.type = 'dog';
dog.name = 'Bumper';
dog.age = 11;
dog.mass = 19.5;
dog.hobbies = {'eat','sleep'};
dog.food = containers.Map({7,12,15,19},{'feed','meat','feed','feed'});
dog.orientation = [1 0 0; 0 2 1; 0 3 -1];
dog.enemies = {cat};

test.createInput(dog,fullfile(mfilename,'valueAccess'));


% Test 2: modular files

% Create satellite body
bodies.Earth.useDefaultSettings = true;
bodies.Moon.useDefaultSettings = true;
bodies.Sun.useDefaultSettings = true;
bodies.sat.mass = 500;
test.createInput(bodies,fullfile(mfilename,'modular','bodies'));
simulation.bodies = '$(bodies.json){Earth:Earth,satellite:sat}';

% Define Tudat variables
variables.time.type = 'independent';
variables.position.body = 'satellite';
variables.position.dependentVariableType = 'relativePosition';
variables.position.relatieToBody = 'Earth';
variables.velocity.body = 'satellite';
variables.velocity.dependentVariableType = 'relativeVelocity';
variables.velocity.relatieToBody = 'Earth';
test.createInput(variables,fullfile(mfilename,'modular','variables','main'));

% Define the propagator to use
propagator.centralBodies = {'Earth'};
propagator.bodiesToPropagate = {'satellite'};
test.createInput(propagator,fullfile(mfilename,'modular','propagator'));
simulation.propagators = {'$(propagator.json)'};

% Define the itegrator to use
integrator.type = 'rungeKutta4';
integrator.stepSize = 30;
test.createInput(integrator,fullfile(mfilename,'modular','rk4'));
simulation.integrator = '$(rk4)';

% Define results to export
% Paths are relative to the main.json file directory
export{1}.file = sprintf('@path(%s)',fullfile('..','outputs','epochs.txt'));
export{1}.variables = '$(../variables){time,}';
export{2}.file = sprintf('@path(%s)',fullfile('..','states.txt'));
export{2}.variables = '$(../variables/main.json){position,velocity}';
test.createInput(export,fullfile(mfilename,'modular','export','export'));
simulation.export = '$(export/export)';

% Export the simulation object to the main file
test.createInput(simulation,fullfile(mfilename,'modular','main'));


% Test 3: mergeable

test.createInput(integrator,fullfile(mfilename,'mergeable','rk4'));
test.createInput(json.merge('$(../rk4.json)','stepSize',20),...
    fullfile(mfilename,'mergeable','inputs','merge1'));

simulation = {};
integrator.initialTimes = [0 86400];
simulation.integrator = integrator;
test.createInput(simulation,fullfile(mfilename,'mergeable','shared'));
test.createInput(json.merge('$(../shared.json)','integrator.stepSize',20),...
    fullfile(mfilename,'mergeable','inputs','merge2'));

simulation = {};
integrator.initialTimes = [0 86400];
simulation.integrator = integrator;
test.createInput(simulation,fullfile(mfilename,'mergeable','shared'));
spice.useStandardKernels = true;
spice.preloadEpehemeris = false;
test.createInput(json.merge('$(merge2.json)','integrator.initialTimes[1]',43200,...
    'integrator.initialTimes[2]',86400,'spice',spice),fullfile(mfilename,'mergeable','inputs','merge3'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


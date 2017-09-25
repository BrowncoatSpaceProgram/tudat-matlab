function [failCount,testOutput] = unitTestSimulationInnerSolarSystem

tudat.load();


% Create input files for tests

% barycentric

% Simulation
t0 = 1e7;  % seconds since J2000
tf = t0 + convert.toSI(30,'d');  % 1 month later
simulation = Simulation(t0,tf);
simulation.spice.preloadEphemeris = false;

% Bodies
simulation.addBodies(Sun,Mercury,Venus,Earth,Moon,Mars);

% Accelerations
bodyNames = fieldnames(simulation.bodies);
for i = 1:length(bodyNames)
    for j = 1:length(bodyNames)
        if i ~= j
            accelerations.(bodyNames{j}).(bodyNames{i}) = {PointMassGravity()};
        end
    end
end

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = repmat({'SSB'},size(bodyNames));
propagator.bodiesToPropagate = bodyNames;
propagator.accelerations = accelerations;
simulation.propagators = {propagator};

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 3600;

% Generate input file
test.createInput(simulation,fullfile(mfilename,'barycentric'));


% hierarchical

% Change central bodies hierarchy
propagator.centralBodies = {'SSB','Sun','Sun','Sun','Earth','Sun'};

% Generate input file
test.createInput(simulation,fullfile(mfilename,'hierarchical'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


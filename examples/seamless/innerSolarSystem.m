%% Inner Solar System Propagation

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation();
simulation.initialEpoch = 1e7;  % seconds since J2000
simulation.finalEpoch = simulation.initialEpoch + convert.toSI(2,'y');  % two years later
simulation.spice.preloadEphemeris = false;

% Bodies
simulation.addBodies(Sun,Mercury,Venus,Earth,Moon,Mars);

% Accelerations
bodyNames = fieldnames(simulation.bodies);
for i = 1:length(bodyNames)
    for j = 1:length(bodyNames)
        if i ~= j
            accelerations.(bodyNames{j}).(bodyNames{i}) = PointMassGravity();
        end
    end
end

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = repmat({'SSB'},size(bodyNames));
propagator.bodiesToPropagate = bodyNames;
propagator.accelerations = accelerations;
simulation.propagator = propagator;

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 3600;


%% RUN

simulation.run();


%% RESULTS

% Retrieve posotions for each body
for i = 1:length(bodyNames)
    fromIndex = 2 + (i-1)*6;
    toIndex = fromIndex + 2;
    r.(bodyNames{i}) = convert.fromSI(simulation.results.numericalSolution(:,fromIndex:toIndex),'AU');
end

% 3D plot of orbits
figure;
hold on;
for i = 1:length(bodyNames)
    bodyPosition = r.(bodyNames{i});
    plot3(bodyPosition(:,1),bodyPosition(:,2),bodyPosition(:,3));
end
legend(bodyNames{:});
axis([-2 2 -2 2 -0.1 0.1]);
axis equal;
grid on;
xlabel('X [AU]');
ylabel('Y [AU]');
zlabel('Z [AU]');
hold off;


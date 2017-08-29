%% Inner Solar System Propagation

clc; clear all;
tudat.load();


%% SET UP

simulation = Simulation(1e7,1e7+convert.toSI(2,'y'));
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp','naif0009.tls');
simulation.spice.preloadKernels = false;

% Bodies
bodyNames = {'Sun','Mercury','Venus','Earth','Moon','Mars'};
simulation.addBodies(bodyNames{:});

% Accelerations
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
simulation.integrator = Integrator(Integrators.rungeKutta4,'1 h');


%% RUN

simulation.run();


%% RESULTS

% Retrieve states for each body
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

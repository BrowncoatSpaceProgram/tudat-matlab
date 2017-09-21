%% Galileo Constellation Simulation

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,convert.toSI(1,'d'),'SSB','J2000');
simulation.spice.preloadEphemeris = false;

% Satellites
numberOfSatellites = 30;
numberOfPlanes = 3;
numberOfSatellitesPerPlane = numberOfSatellites/numberOfPlanes;
for i = 1:numberOfSatellites
    simulation.addBodies(Body(sprintf('Satellite%i',i)));
end
satelliteNames = fieldnames(simulation.bodies);

% Celestial bodies
simulation.addBodies(Earth);
simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(6,1));
simulation.bodies.Earth.ephemeris.frameOrientation = 'J2000';

% Initial states
raans = mod(floor(((1:numberOfSatellites)-1)/numberOfSatellitesPerPlane),numberOfPlanes)*360/numberOfPlanes;
trueAnomalies = mod((1:numberOfSatellites)-1,numberOfSatellitesPerPlane)*360/numberOfSatellitesPerPlane;
for i = 1:numberOfSatellites
    satellite = simulation.bodies.(satelliteNames{i});
    satellite.initialState.semiMajorAxis = 23222e3 + 6378.1e3;
    satellite.initialState.inclination = deg2rad(56);
    satellite.initialState.longitudeOfAscendingNode = deg2rad(raans(i));
    satellite.initialState.trueAnomaly = deg2rad(trueAnomalies(i));
end

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = repmat({'Earth'},1,numberOfSatellites);
propagator.bodiesToPropagate = satelliteNames;
for i = 1:numberOfSatellites
    propagator.accelerations.(satelliteNames{i}).Earth = SphericalHarmonicGravity(4,0);
end
simulation.propagator = propagator;

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 30;

% Define results to generate
for i = 1:numberOfSatellites
    simulation.addResultsToSave(sprintf('r%i',i),sprintf('%s.relativePosition-Earth',satelliteNames{i}));
end


%% RUN

simulation.run();


%% RESULTS

% 3D plot of orbits
ccodes = mod(floor(((1:numberOfSatellites)-1)/numberOfSatellitesPerPlane),numberOfPlanes) + 1;
colors = get(groot,'DefaultAxesColorOrder');
figure;
hold on;
for i = 1:numberOfSatellitesPerPlane:numberOfSatellites
    r = simulation.results.(sprintf('r%i',i))/1e3;
    plot3(r(:,1),r(:,2),r(:,3),'Color',colors(ccodes(i),:));
end
view(-30,30);
axis equal;
grid on;
xlabel('X [km]');
ylabel('Y [km]');
zlabel('Z [km]');

% Add Earth
[x,y,z] = sphere;
radius = Earth.averageRadius/1e3;
surf(x*radius,y*radius,z*radius);

% Add satellites at final positions
for i = 1:numberOfSatellites
    r = simulation.results.(sprintf('r%i',i))/1e3;
    plot3(r(end,1),r(end,2),r(end,3),'.','Color',colors(ccodes(i),:),'MarkerSize',18);
end
hold off;


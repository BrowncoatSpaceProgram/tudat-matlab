function [failCount,testOutput] = simulationSingleSatellite(generateInput)

tudat.load();

if nargin < 1
    generateInput = false;
end

% Create input files for tests
if generateInput
    % Simulation
    simulation = Simulation(0,3600);
    
    % Bodies
    asterix = Body('asterix');
    asterix.initialState.semiMajorAxis = 7500e3;
    asterix.initialState.eccentricity = 0.1;
    asterix.initialState.inclination = 1.4888;
    asterix.initialState.argumentOfPeriapsis = 4.1137;
    asterix.initialState.longitudeOfAscendingNode = 0.4084;
    asterix.initialState.trueAnomaly = 2.4412;
    simulation.addBodies(Earth,asterix);
    simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(6,1));
    
    % Propagator
    propagator = TranslationalPropagator();
    propagator.centralBodies = Earth;
    propagator.bodiesToPropagate = asterix;
    propagator.accelerations.asterix.Earth = PointMassGravity();
    simulation.propagator = propagator;
    
    % Integrator
    simulation.integrator.type = Integrators.rungeKutta4;
    simulation.integrator.stepSize = 10;
    
    % Generate input file
    test.createInput(simulation,fullfile(mfilename,'main'));
end

% Run test
[failCount,testOutput] = test.runUnitTest(mfilename);


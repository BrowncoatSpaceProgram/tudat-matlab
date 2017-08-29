clc; clear;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.ephemeris)
fprintf([json.encode(sat) '\n\n']);

sat.ephemeris = ApproximatePlanetPositionEphemeris(BodiesWithEphemerisData.earthMoonBarycenter,false);
fprintf([json.encode(sat) '\n\n']);

sat.ephemeris = ConstantEphemeris([0 1 0]);
fprintf([json.encode(sat) '\n\n']);

sat.ephemeris = DirectSpiceEphemeris();
fprintf([json.encode(sat) '\n\n']);

sat.ephemeris = InterpolatedSpiceEphemeris();
sat.ephemeris.initialTime = 0;
sat.ephemeris.finalTime = 100;
sat.ephemeris.timeStep = 10;
sat.ephemeris.interpolator = LagrangeInterpolator(4);
fprintf([json.encode(sat) '\n\n']);

sat.ephemeris = KeplerEphemeris();
sat.ephemeris.initialStateInKeplerianElements = [7e6 0.1 0 0 0 0];
sat.ephemeris.epochOfInitialState = 0;
sat.ephemeris.centralBodyGravitationalParameter = constants.standardGravitationalParameter.earth;
fprintf([json.encode(sat) '\n\n']);

sat.ephemeris = TabulatedEphemeris();
sat.ephemeris.bodyStateHistory = containers.Map({0 1 2},{[1 0 0] [3 0 0] [4 0 0]});
fprintf([json.encode(sat) '\n\n']);



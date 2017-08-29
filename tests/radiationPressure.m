function failcount = radiationPressure

failcount = 0;
tudat.load();

sat = Body('sat');
sat.mass = 15;
sat.referenceArea = 2;

isempty(sat.radiationPressure)
fprintf([json.encode(sat) '\n\n']);

sat.radiationPressureCoefficient = 1.5;
sat.radiationPressure.Sun.occultingBodies = {'Earth','Moon'};
fprintf([json.encode(sat) '\n\n']);

sat.radiationPressure.Sun = CannonBallRadiationPressure();
sat.radiationPressure.Sun.radiationPressureCoefficient = 1.8;
fprintf([json.encode(sat) '\n\n']);

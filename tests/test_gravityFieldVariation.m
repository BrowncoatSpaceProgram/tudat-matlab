clc; clear;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.gravityFieldVariation)
fprintf([json.encode(sat) '\n\n']);

sat.gravityFieldVariation = GravityFieldVariation('basicSolidBody');
fprintf([json.encode(sat) '\n\n']);


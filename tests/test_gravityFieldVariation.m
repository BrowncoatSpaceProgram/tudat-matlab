clc; clear all;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.gravityFieldVariations)
fprintf([json.encode(sat) '\n\n']);

sat.gravityFieldVariations = GravityFieldVariations('basicSolidBody');
fprintf([json.encode(sat) '\n\n']);


clc; clear all;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.rotationModel)
fprintf([json.encode(sat) '\n\n']);

sat.rotationModel = SpiceRotationModel();
sat.rotationModel.originalFrame = 'A';
sat.rotationModel.targetFrame = 'B';
fprintf([json.encode(sat) '\n\n']);

sat.rotationModel = SimpleRotationModel();
sat.rotationModel.originalFrame = 'A';
sat.rotationModel.targetFrame = 'B';
sat.rotationModel.initialTime = '2000-01-01 5:00';
sat.rotationModel.rotationRate = 2e-5;
sat.rotationModel.initialOrientation = [1 0 0; 0 sqrt(2)/2 -sqrt(2)/2; 0 -sqrt(2)/2 sqrt(2)/2];
fprintf([json.encode(sat) '\n\n']);

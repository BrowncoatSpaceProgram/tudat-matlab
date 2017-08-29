clc; clear;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.gravityFieldVariation)
fprintf([json.encode(sat) '\n\n']);

sat.gravityFieldVariation = BasicSolidBodyGravityFieldVariation();
sat.gravityFieldVariation.deformingBodies = 'Moon';
sat.gravityFieldVariation.loveNumbers = [[1+2i 2-1i 3+1e-5i]; [0.5i 2i 4-2i]; [-3 -5+1i 6+0.5i]];
sat.gravityFieldVariation.referenceRadius = constants.radius.earth;
fprintf([json.encode(sat) '\n\n']);

sat.gravityFieldVariation.modelInterpolation = ModelInterpolation(0,100,10,Interpolator('linear'));
fprintf([json.encode(sat) '\n\n']);

sat.gravityFieldVariation = TabulatedGravityFieldVariation();
sat.gravityFieldVariation.cosineCoefficientCorrections = [0 1 2];
sat.gravityFieldVariation.sineCoefficientCorrections = [-1 4 5];
sat.gravityFieldVariation.minimumDegree = 4;
sat.gravityFieldVariation.minimumOrder = 4;
sat.gravityFieldVariation.modelInterpolation.interpolator.type = 'cubicSpline';
fprintf([json.encode(sat) '\n\n']);


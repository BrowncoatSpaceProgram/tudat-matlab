function failcount = aerodynamics

failcount = 0;
tudat.load();

sat = Body('sat');
isempty(sat.aerodynamics)

sat.dragCoefficient = -2.2;
sat.aerodynamics.momentCoefficients = [1 2 3];
sat.aerodynamics.referenceLength = 3;
sat.aerodynamics.lateralReferenceLength = 4;
sat.aerodynamics.momentReferencePoint = [0 0 0];
sat.aerodynamics.areCoefficientsInNegativeAxisDirection = false;
fprintf([json.encode(sat) '\n\n']);

sat.aerodynamics = TabulatedAerodynamics();
sat.aerodynamics.independentVariableName = AerodynamicVariables.angleOfAttack;
sat.aerodynamics.independentVariables = [1 10];
sat.aerodynamics.forceCoefficients = [2.2 0 0; 2.5 0 0];
sat.aerodynamics.interpolator.type = 'linear';
% sat.aerodynamics.momentCoefficients = [1 2 3; 5 8 7];
fprintf([json.encode(sat) '\n\n']);


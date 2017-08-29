function failcount = gravityField

failcount = 0;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.gravityField)
fprintf([json.encode(sat) '\n\n']);

sat.gravityField = PointMassGravityField();
sat.gravityField.gravitationalParameter = constants.standardGravitationalParameter.earth;
fprintf([json.encode(sat) '\n\n']);

sat.gravityField = PointMassSpiceGravityField();
fprintf([json.encode(sat) '\n\n']);

sat.gravityField = SphericalHarmonicGravityField('ggm02c');
fprintf([json.encode(sat) '\n\n']);

sat.gravityField = SphericalHarmonicGravityField();
sat.gravityField.file = 'sh.txt';
sat.gravityField.associatedReferenceFrame = 'IAU_Earth';
sat.gravityField.maximumDegree = 50;
sat.gravityField.maximumOrder = 50;
fprintf([json.encode(sat) '\n\n']);

sat.gravityField.gravitationalParameterIndex = -1;
sat.gravityField.referenceRadiusIndex = -1;
sat.gravityField.gravitationalParameter = constants.standardGravitationalParameter.earth;
sat.gravityField.referenceRadius = constants.radius.earth;
fprintf([json.encode(sat) '\n\n']);

sat.gravityField = SphericalHarmonicGravityField();
sat.gravityField.associatedReferenceFrame = 'IAU_Earth';
sat.gravityField.gravitationalParameter = constants.standardGravitationalParameter.earth;
sat.gravityField.referenceRadius = constants.radius.earth;
sat.gravityField.cosineCoefficients = [1 0; 0 0];
sat.gravityField.sineCoefficients = [0 0; 0 0];
fprintf([json.encode(sat) '\n\n']);

% error('falseAlarm');


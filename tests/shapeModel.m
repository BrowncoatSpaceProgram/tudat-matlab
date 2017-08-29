clc; clear;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.shapeModel)
fprintf([json.encode(sat) '\n\n']);

sat.shapeModel = SphericalShapeModel();
sat.shapeModel.radius = constants.radius.earth;
fprintf([json.encode(sat) '\n\n']);

sat.shapeModel = SphericalSpiceShapeModel();
fprintf([json.encode(sat) '\n\n']);

sat.shapeModel = OblateSphericalShapeModel();
sat.shapeModel.equatorialRadius = 6.378e6;
sat.shapeModel.flattening = 0.0034;
fprintf([json.encode(sat) '\n\n']);


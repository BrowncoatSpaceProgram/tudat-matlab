function [failCount,testOutput] = shapeModel(generateInput)

tudat.load();

if nargin < 1
    generateInput = false;
end

% Create input files for tests
if generateInput
    % Test 1: rotation model types
    test.createInputForEnum(?ShapeModels,fullfile(mfilename,'types'));
    
    % Test 2: spherical shape model
    sm = SphericalShapeModel();
    sm.radius = 6.4e6;
    test.createInput(sm,fullfile(mfilename,'spherical'));
    
    % Test 3: spherical Spice shape model
    sm = SphericalSpiceShapeModel();
    test.createInput(sm,fullfile(mfilename,'sphericalSpice'));
    
    % Test 4: oblate spherical shape model
    sm = OblateSphericalShapeModel();
    sm.equatorialRadius = 6.378e6;
    sm.flattening = 0.0034;
    test.createInput(sm,fullfile(mfilename,'oblateSpherical'));
end

% Run tests
[failCount,testOutput] = test.runUnitTest(mfilename);


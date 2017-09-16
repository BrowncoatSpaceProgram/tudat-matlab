function [failCount,testOutput] = gravityField(generateInput)

tudat.load();

if nargin < 1
    generateInput = false;
end

% Create input files for tests
if generateInput
    % Test 1: gravity field types
    test.createInputForEnum(?GravityFields,fullfile(mfilename,'types'));
    
    % Test 2: spherical harmonic models
    test.createInputForEnum(?SphericalHarmonicModels,fullfile(mfilename,'sphericalHarmonicModels'));
    
    % Test 3: point mass gravity field
    gf = PointMassGravityField();
    gf.gravitationalParameter = 4e14;
    test.createInput(gf,fullfile(mfilename,'pointMass'));
    
    % Test 4: point mass Spice gravity field
    gf = PointMassSpiceGravityField();
    test.createInput(gf,fullfile(mfilename,'pointMassSpice'));
    
    % Test 5: spherical harmonic gravity field (from named model)
    gf = SphericalHarmonicGravityField('ggm02c');
    test.createInput(gf,fullfile(mfilename,'sphericalHarmonic_model'));
    
    % Test 6: spherical harmonic gravity field (from file)
    gf = SphericalHarmonicGravityField();
    gf.file = 'sh.txt';
    gf.associatedReferenceFrame = 'IAU_Earth';
    gf.maximumDegree = 2;
    gf.maximumOrder = 1;
    test.createInput(gf,fullfile(mfilename,'sphericalHarmonic_file'));
    
    % Test 7: spherical harmonic gravity field (from file, manual parameters)
    gf.file = 'sh_manualparam.txt';
    gf.gravitationalParameterIndex = -1;
    gf.referenceRadiusIndex = -1;
    gf.gravitationalParameter = 4e14;
    gf.referenceRadius = 6.4e6;
    test.createInput(gf,fullfile(mfilename,'sphericalHarmonic_file_manualparam'));
    
    % Test 8: spherical harmonic gravity field (direct)
    gf = SphericalHarmonicGravityField();
    gf.associatedReferenceFrame = 'IAU_Earth';
    gf.gravitationalParameter = 4e14;
    gf.referenceRadius = 6.4e6;
    gf.cosineCoefficients = [1 0; 0 0];
    gf.sineCoefficients = [0 0; 0 0];
    test.createInput(gf,fullfile(mfilename,'sphericalHarmonic_direct'));
end

% Run tests
[failCount,testOutput] = test.runUnitTest(mfilename);


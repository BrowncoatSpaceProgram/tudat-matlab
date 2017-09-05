function failcount = aerodynamics

tudat.load();

% Create input files for tests

% Test 1: aerodynamic coefficients types
test.createInputForEnum(?AerodynamicCoefficients,[mfilename '_coefficientsTypes']);

% Test 2: aerodynamic variables
test.createInputForEnum(?AerodynamicVariables,[mfilename '_variables']);

% Test 3: constant aerodynamics (only drag coefficient)
ca = ConstantAerodynamics();
ca.referenceArea = 10.5;
ca.dragCoefficient = 2.2;
test.createInput(ca,[mfilename '_dragCoefficient']);

% Test 4: constant aerodynamics (full)
ca.referenceLength = 5;
ca.lateralReferenceLength = 4;
ca.momentReferencePoint = [0.7 0.8 0.9];
ca.forceCoefficients = [1 2 3];
ca.momentCoefficients = [0 1e-3 -0.1];
ca.areCoefficientsInAerodynamicFrame = true;
ca.areCoefficientsInNegativeAxisDirection = false;
test.createInput(ca,[mfilename '_constant']);

% Test 5: tabulated aerodynamics (1 dimension)
ta = TabulatedAerodynamics();
ta.independentVariables = 0:3;
ta.forceCoefficients = [0.7, 0.8, 0.9; 1.7, 1.8, 1.9; 2.7, 2.8, 2.9; 3.7, 3.8, 3.9];
ta.momentCoefficients = [1.0, 2.0, 3.0; 1.0, 1.0, 1.0; 2.0, 2.0, 2.0; 3.0, 3.0, 3.0];
ta.referenceLength = 5;
ta.referenceArea = 10.5;
ta.lateralReferenceLength = 4;
ta.momentReferencePoint = [0.7 0.8 0.9];
ta.independentVariableNames = AerodynamicVariables.angleOfSideslip;
ta.interpolator.type = Interpolators.cubicSpline;
ta.areCoefficientsInAerodynamicFrame = false;
ta.areCoefficientsInNegativeAxisDirection = false;
test.createInput(ta,[mfilename '_tabulated1']);

% Test 6: tabulated aerodynamics (N dimensions)
ta = TabulatedAerodynamics();
ta.forceCoefficients = {'aurora_CD.txt','','aurora_CL.txt'};
ta.momentCoefficients = {'','aurora_Cm.txt',''};
ta.referenceLength = 5;
ta.referenceArea = 10.5;
ta.lateralReferenceLength = 4;
ta.momentReferencePoint = [0.7 0.8 0.9];
ta.independentVariableNames = {AerodynamicVariables.machNumber, AerodynamicVariables.angleOfAttack};
ta.areCoefficientsInAerodynamicFrame = true;
ta.areCoefficientsInNegativeAxisDirection = true;
test.createInput(ta,[mfilename '_tabulatedN']);

% Run tests

failcount = test.runUnitTest(mfilename);


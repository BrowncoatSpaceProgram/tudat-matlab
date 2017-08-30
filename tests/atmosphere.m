function failcount = atmosphere

tudat.load();

% Create input files for tests

% Test 1: atmosphere models
test.createInputForEnum(?AtmosphereModels,[mfilename '_models']);

% Test 2: exponential atmosphere
atm = ExponentialAtmosphere();
atm.densityScaleHeight = 5;
atm.constantTemperature = 290;
atm.densityAtZeroAltitude = 1;
atm.specificGasConstant = 3;
test.createInput(atm,[mfilename '_exponential']);

% Test 3: tabulated atmosphere
atm = TabulatedAtmosphere('atmosphereTable.foo');
test.createInput(atm,[mfilename '_tabulated']);

% Test 4: NRLMSISE00 atmosphere
atm = Atmosphere('nrlmsise00');
test.createInput(atm,[mfilename '_nrlmsise00']);

% Test 5: NRLMSISE00 atmosphere (custom space weather file)
atm = NRLMSISE00Atmosphere('spaceWeatherFile.foo');
test.createInput(atm,[mfilename '_nrlmsise00_custom']);


% Run tests

failcount = test.runUnitTest(mfilename);


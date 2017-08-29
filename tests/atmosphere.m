function failcount = atmosphere

failcount = 0;
tudat.load();

sat = Body('sat');
sat.mass = 15;

isempty(sat.atmosphere)
fprintf([json.encode(sat) '\n\n']);

sat.atmosphere = ExponentialAtmosphere();
sat.atmosphere.densityScaleHeight = 5;
sat.atmosphere.densityAtZeroAltitude = 1;
sat.atmosphere.constantTemperature = 290;
sat.atmosphere.specificGasConstant = 5;
fprintf([json.encode(sat) '\n\n']);

sat.atmosphere = TabulatedAtmosphere('tab_atm.txt');
fprintf([json.encode(sat) '\n\n']);

sat.atmosphere = Atmosphere('nrlmsise00');
fprintf([json.encode(sat) '\n\n']);

sat.atmosphere = NRLMSISE00Atmosphere('sw.txt');
fprintf([json.encode(sat) '\n\n']);


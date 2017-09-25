clc; clear;
tudat.load();

% Import epochs from output/epochs.txt
% If propagation failed (and results are only available until the epoch of failure), print a warning
epochs = import.results(fullfile('output','epochs.txt'),'warn');

% Import states from output/estates.txt
% No need to print a warning again if propagation failed
states = import.results(fullfile('output','states.txt'));

% Use functions included in the package to quickly plot Keplerian
% components history or apoapsis and periapsis altitudes hisotry
figure;
plot.keplerianComponentsHistory('Epochs',epochs,'CartesianStates',states,'CentralBody',Earth);
figure;
plot.apoapsisPeriapsisAltitudesHistory('Epochs',epochs,'CartesianStates',states,'CentralBody',Earth);

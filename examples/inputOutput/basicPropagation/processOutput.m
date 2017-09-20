clc; clear;
tudat.load();

% Import results from tmpout/results.txt
% Use the function import.results with the argument 'warn' to print a message
% in case that the propagation failed
results = import.results(fullfile('tmpout','results.txt'),'warn');

% Get epochs (first column) and positions (second, third and fourth columns)
t = results(:,1);
r = results(:,2:4);

% Plot X, Y and Z cartesian components history
figure;
plot(convert.epochToDate(t),r/1e3);
legend('x','y','z','Location','South','Orientation','Horizontal');
ylabel('Position [km]');
grid on;


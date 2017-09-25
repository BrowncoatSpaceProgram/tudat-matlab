clc; clear variables;
tudat.load();

files = dir(fullfile('output','*.txt'));
filenames = {files.name};

figure;
hold on;
ylabel('Altitude [km]');
grid on;
legendEntries = cell(size(filenames));
for i = 1:length(filenames)
    [~,tok] = regexp(filenames{i},'mass(.+)\.txt','match','tokens');
    legendEntries{i} = tok{1}{1};
    outputFile = fullfile('output',filenames{i});
    
    % Load results using import.results with argument 'warn'.
    % This will print a warning in case the propagation failed.
    % In this case, the first propagation (mass200) failed because
    % the limit for the altitude was set too small (80 km).
    % At this altitude, a lightweight satellite is re-entering so quickly
    % that a very small integration step is required. The lower limit for the
    % step-size of the variable step-size integrator, which was set to 5 s, is
    % exceeded, so the propagation fails returning the results up to that point.
    results = import.results(outputFile,'warn');
    
    t = results(:,1);
    h = results(:,8);
    plot(convert.epochToDate(t),h/1e3);
end
l = legend(legendEntries);
l.Title.String = 'Mass [kg]';
hold off;


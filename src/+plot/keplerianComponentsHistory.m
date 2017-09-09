function keplerianComponentsHistory(varargin)

if mod(length(varargin),2) == 1
    varargin = horzcat('CartesianStatesHistory',varargin);
end
[epochs,states] = support.epochsKeplerianStates(varargin{:});
t_units = support.optionalArgument(varargin,'TimeUnits','date');

% Support for plotting multiple cases
if isa(states,'cell')
    statesCell = states;
    if isa(epochs,'cell')
        epochsCell = epochs;
    else
        epochsCell = repmat({epochs},length(states));
    end
else
    statesCell = {states};
    epochsCell = {epochs};
end

% Load the states from a results object or directly from the first input argument
for i = 1:length(statesCell)
    t = epochsCell{i};
    components = statesCell{i};
    
    % Convert time
    t = convert.epochTo(t,t_units);
    if strcmpi(t_units,'date')
        xl = '';
    else
        xl = sprintf('Time [%s]',t_units);
    end
    
    subplot(2,3,1);
    hold on;
    plot(t,components(:,1)/1e3);
    grid on;
    xlabel(xl);
    ylabel('Semi-major axis [km]');
    
    subplot(2,3,2);
    hold on;
    plot(t,components(:,2));
    grid on;
    xlabel(xl);
    ylabel('Eccentricity [-]');
    
    subplot(2,3,3);
    hold on;
    plot(t,rad2deg(components(:,3)));
    grid on;
    xlabel(xl);
    ylabel('Inclination [deg]');
    
    subplot(2,3,4);
    hold on;
    plot(t,rad2deg(components(:,4)));
    grid on;
    xlabel(xl);
    ylabel('Argument of perigee [deg]');
    
    subplot(2,3,5);
    hold on;
    plot(t,rad2deg(components(:,5)));
    grid on;
    xlabel(xl);
    ylabel('Longitude of the ascending node [deg]');
    
    subplot(2,3,6);
    hold on;
    plot(t,rad2deg(components(:,6)));
    grid on;
    xlabel(xl);
    ylabel('True anomaly [deg]');
end


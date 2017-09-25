function fig = apoapsisPeriapsisAltitudesHistory(varargin)

if mod(length(varargin),2) == 1
    varargin = horzcat('CartesianStatesHistory',varargin);
end
[epochs,states] = support.epochsCartesianStates(varargin{:});
t_units = support.optionalArgument(varargin,'TimeUnits','date');
plot_title = support.optionalArgument(varargin,'Title','');
plot_legends = support.optionalArgument(varargin,'Legends',{});
line_style = support.optionalArgument(varargin,'LineStyle','-');

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
    
    % Get apo peri altitudes
    centralBody = support.optionalArgument(varargin,'CentralBody',[]);
    [ha,hp] = compute.apoapsisPeriapsisAltitudes(components,centralBody);
    
    subplot(2,1,1);
    hold on;
    plot(t,ha/1e3,line_style);
    grid on;
    xlabel(xl);
    ylabel('Apoapsis altitude [km]');
    if i == 1
        title(plot_title);
    end
    if ~isempty(plot_legends) && i == length(objs)
        legend(plot_legends,'Location','NorthEastOutside');
    end
    
    subplot(2,1,2);
    hold on;
    plot(t,hp/1e3);
    grid on;
    xlabel(xl);
    ylabel('Periapsis altitude [km]');
    if ~isempty(plot_legends) && i == length(objs)
        legend(plot_legends,'Location','NorthEastOutside');
    end
end

fig = gcf;
hold off;

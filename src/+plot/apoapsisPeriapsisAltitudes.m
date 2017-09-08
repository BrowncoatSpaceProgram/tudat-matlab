function fig = apoapsisPeriapsisAltitudes(obj,centralBody,varargin)

t_units = support.optionalArgument(varargin,'TimeUnits','date');
plot_title = support.optionalArgument(varargin,'Title','');
plot_legends = support.optionalArgument(varargin,'Legends',{});
line_style = support.optionalArgument(varargin,'LineStyle','-');

% Support for plotting multiple cases
if isa(obj,'cell')
    objs = obj;
else
    objs = {obj};
end

% Load the states from a results object or directly from the first input argument
for i = 1:length(objs)
    obj = objs{i};
    t = obj(:,1);
    states = obj(:,2:7);
    support.assertValidState(states);
    cartesian = support.isCartesianState(states);
    
    % Transform to Keplerian components if necessary
    if cartesian
        states = convert.cartesianToKeplerian(states,centralBody);
    end
    
    % Convert time
    t = convert.epochTo(t,t_units);
    if strcmpi(t_units,'date')
        xl = '';
    else
        xl = sprintf('Time [%s]',t_units);
    end
    
    % Get apo peri altitudes
    [ha,hp] = compute.apoapsisPeriapsisAltitudes(states,varargin{:});
    
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

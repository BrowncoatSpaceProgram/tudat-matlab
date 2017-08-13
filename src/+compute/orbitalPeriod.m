function T = orbitalPeriod(state,varargin)

mu = support.optionalArgument(constants.standardGravitationalParameter.earth, ...
    'StandardGravitationalParameter',varargin);
units = support.optionalArgument('s','Units',varargin);

support.assertValidState(state);
if support.isCartesianState(state)
    state = convert.cartesianToKeplerian(state,'StandardGravitationalParameter',mu);
end

% Obtain the altitudes
a = state(:,1);  % semi-major axis
T = 2*pi*sqrt(a.^3/mu);
T = convert.secondsTo(T,units);

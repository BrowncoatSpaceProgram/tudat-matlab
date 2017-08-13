function [ha,hp] = apoapsisPeriapsisAltitude(state,varargin)
%Determine perigee and apogee altitudes [m] from state:
%   [ha,hp] = perigeeApogeeAltitude(keplerianState)
%   [ha,hp] = perigeeApogeeAltitude(cartesianState)
%   [ha,hp] = perigeeApogeeAltitude([X,Y,Z])
%Optional arguments: 'Radius', 'StandardGravitationalParameter'.
%By default the Earth's are used.

R = support.optionalArgument(constants.radius.earth,'Radius',varargin);
mu = support.optionalArgument(constants.standardGravitationalParameter.earth, ...
    'StandardGravitationalParameter',varargin);

[~,m] = size(state);
if m == 3
    cartesian = true;
else
    support.assertValidState(state);
    cartesian = support.isCartesianState(state);
end

if cartesian
    state = convert.cartesianToKeplerian(state,'StandardGravitationalParameter',mu);
end

a = state(:,1);
e = state(:,2);
hp = a.*(1-e) - R;
ha = a.*(1+e) - R;


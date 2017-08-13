function h = altitude(obj,varargin)
%Determine altitude [m] from state:
%   h = altitude(keplerianState)
%   h = altitude(cartesianState)
%   h = altitude([X,Y,Z])
%Optional arguments: 'Radius', 'StandardGravitationalParameter'.
%By default the Earth's are used.

R = support.optionalArgument(constants.radius.earth,'Radius',varargin);
mu = support.optionalArgument(constants.standardGravitationalParameter.earth, ...
    'StandardGravitationalParameter',varargin);

states = obj;
[~,m] = size(states);
if m == 3
    cartesian = true;
else
    support.assertValidState(states);
    cartesian = support.isCartesianState(states);
end

if ~cartesian
    states = convert.keplerianToCartesian(states,'StandardGravitationalParameter',mu);
end

positions = states(:,1:3);  % Get [x,y,z]
r = compute.normPerRows(positions);  % Obtain the distances from the centre of the central body
h = r - R;


function L = longitudeSubsatellitePoint(arg1,arg2)
%Determine longitude of the subsatellite point of a spacecraft:
%   L = longitudeSubsatellitePoint(epoch,state)
%   L = longitudeSubsatellitePoint([epoch state])
%The longitude is given in degrees East from the Greenwich meridian.

if nargin == 1
    epochs = arg1(:,1);
    states = arg1(:,2:end);
elseif nargin == 2
    epochs = arg1(:);
    states = arg2;
end
[~,m] = size(states);
if m == 2 || m == 3
    cartesian = true;
else
    support.assertValidState(states);
    cartesian = support.isCartesianState(states);
end

if ~cartesian
    states = convert.keplerianToCartesian(states,'StandardGravitationalParameter',...
        constants.standardGravitationalParameter.earth);
end

L = mod( mod(atan2d(states(:,2),states(:,1)),360) - convert.epochToGST(epochs), 360);

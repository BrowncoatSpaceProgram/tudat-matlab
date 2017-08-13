function RAAN = raanForLaunchFromLocation(latitude,longitude,epoch,inclination)
%Right ascension of the ascending node for an orbit launched from an aribitrary location on Earth:
%   RAAN = raanForLaunchFromKourou(epoch,inclination)
%       latitude of launch site [deg]
%       longitude of launch site [deg]
%       epoch of launch [seconds since J2000]
%       inclination of initial orbit [deg]

if any( inclination < abs(latitude) | inclination > 180 - abs(latitude) )
    error(['Satellites launched from a latitude of %g deg '...
        'cannot follow an orbit with inclination %g deg.'],latitude,inclination);
end

% From OCDM, spherical trigonometry
% Longitude of the AN for an orbit launched form (latitude,longitude) with inclination
longitudeAN = mod(longitude - asind(tand(latitude)./tand(inclination)), 360);

% RAAN if launched at epoch
% longitudeAN wrt to current longitude for first point of Aries (whose coordinates are always [Inf 0 0])
RAAN = mod(longitudeAN - compute.longitudeSubsatellitePoint(epoch,[Inf 0 0]), 360);

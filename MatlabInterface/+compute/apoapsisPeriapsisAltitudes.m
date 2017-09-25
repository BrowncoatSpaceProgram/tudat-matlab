function [ha,hp] = apoapsisPeriapsisAltitudes(cartesianState,referenceRadius,gravitationalParameter)
%Determine apoapsis and periapsis altitudes from state:
%   [ha,hp] = apoapsisPeriapsisAltitudes(cartesianState,referenceRadius)

if isa(referenceRadius,'Body')
    body = referenceRadius;
    referenceRadius = body.averageRadius;
    gravitationalParameter = body.gravitationalParameter;
end

keplerianState = convert.cartesianToKeplerian(cartesianState,gravitationalParameter);
a = keplerianState(:,1);
e = keplerianState(:,2);
hp = a.*(1-e) - referenceRadius;
ha = a.*(1+e) - referenceRadius;

end

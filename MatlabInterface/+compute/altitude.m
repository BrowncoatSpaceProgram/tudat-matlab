function h = altitude(states,referenceRadius)
%Determine altitude(s) from state(s):
%   h = altitude(cartesianStates,referenceRadius)

if isa(referenceRadius,'Body')
    body = referenceRadius;
    referenceRadius = body.averageRadius;
end

positions = states(:,1:3);
r = compute.normPerRows(positions);
h = r - referenceRadius;

end

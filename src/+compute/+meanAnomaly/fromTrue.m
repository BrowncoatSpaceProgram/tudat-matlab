function M = fromTrue(f,e)

E = compute.eccentricAnomaly.fromTrue(f,e);
M = compute.meanAnomaly.fromEccentric(E,e);
M = mod(M,2*pi);
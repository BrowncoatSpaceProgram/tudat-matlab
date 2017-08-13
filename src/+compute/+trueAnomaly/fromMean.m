function f = fromMean(M,e)

E = compute.eccentricAnomaly.fromMean(M,e);
f = compute.trueAnomaly.fromEccentric(E,e);
f = mod(f,2*pi);
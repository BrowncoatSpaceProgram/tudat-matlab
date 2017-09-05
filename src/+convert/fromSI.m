function value = fromSI(value,units)
value = convert.toSI(value,['(' units ')^-1']);

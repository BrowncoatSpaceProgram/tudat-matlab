function value = fromSI(value,units)
assert(isnumeric(value),'Please provide a numeric input');
value = value / constants.SIUnits.(lower(units));

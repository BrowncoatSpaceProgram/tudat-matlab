function value = fromSI(value,toUnits)

value = convert.toSI(value,['(' toUnits ')^-1']);

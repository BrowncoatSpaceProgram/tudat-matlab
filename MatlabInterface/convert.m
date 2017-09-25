function value = convert(value,fromUnits,toUnits)

value = convert.toSI(value,[fromUnits '*(' toUnits ')^-1']);

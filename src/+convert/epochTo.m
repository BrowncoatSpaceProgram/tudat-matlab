function t = epochTo(t,units)

if strcmpi(units,'date')
    t = convert.epochToDate(t);
else
    t = units.fromSI(t,units);
end

end

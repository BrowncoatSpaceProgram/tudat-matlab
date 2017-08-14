function t = epochTo(t,units)

if strcmpi(units,'date')
    t = convert.epochToDate(t);
else
    t = convert.fromSI(t,units);
end

function value = toSI(value,fromUnits)

if nargin == 1
    [~,parts] = regexp(value,'(.+) (.+)','match','tokens');
    if isempty(parts)
        error('Please provide the physical magnitude as ''value units'' (e.g. ''1.5 AU'', ''100 km/h'', ''2.5+0.6e-2 m/min^2'')');
    else
        value = eval(parts{1}{1});
        fromUnits = parts{1}{2};
    end
else
    assert(isnumeric(value),'Please provide a numeric input');
end

unitsCommand = regexprep(fromUnits,'([a-z|A-Z])+','SIUnits.(lower(''$1''))');
value = value * eval(unitsCommand);

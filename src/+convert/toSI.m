function value = toSI(value,units)

if nargin == 1
    [~,parts] = regexp(value,'(.+) (.+)','match','tokens');
    if isempty(parts)
        error('Please provide the physical magnitude as ''value units'' (e.g. ''1.5 AU'', ''100 km/h'', ''2.5+0.6e-2 m/min^2'')');
    else
        value = eval(parts{1}{1});
        units = parts{1}{2};
    end
else
    assert(isnumeric(value),'Please provide a numeric input');
end

[~,tokex] = regexp(units,'([a-z|A-Z])+','match','tokenExtents');
unitsCommand = '';
for i = 1:length(units)
    for j = 1:length(tokex)
        if tokex{j}(1) == i
            unitsCommand = [unitsCommand 'constants.SIUnits.'];
        end
    end
    unitsCommand = [unitsCommand lower(units(i))];
end

value = value * eval(unitsCommand);

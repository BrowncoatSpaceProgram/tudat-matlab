function value = toSI(value,units)

if nargin == 1
    parts = split(value,' ');
    if length(parts) ~= 2
        error('Please provide the physical magnitude as ''value units'' (e.g. ''1.5 AU'', ''30 min'', ''100 km/h'')');
    else
        value = eval(parts{1});
        units = parts{2};
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
    unitsCommand = [unitsCommand units(i)];
end

value = value * eval(unitsCommand);

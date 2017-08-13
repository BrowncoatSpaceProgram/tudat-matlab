function value = toSI(value,units)

if nargin == 1
    parts = split(value,' ');
    if length(parts) ~= 2
        error('Please provide the physical magnitude as ''value units'' (e.g. ''1.5 AU'' or ''30 min'')');
    else
        value = str2double(parts{1});
        units = parts{2};
    end
else
    assert(isnumeric(value),'Please provide a numeric input');
end

value = value * constants.SIUnits.(lower(units));

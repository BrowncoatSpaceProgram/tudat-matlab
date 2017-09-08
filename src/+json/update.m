function s = update(s,obj,name,mandatory,formatspec)

value = obj.(name);
if ~isempty(value)
    if nargin >= 5 && ~isempty(formatspec)
        if iscell(value)
            for i = 1:length(value)
                value{i} = sprintf(formatspec,value{i});
            end
        else
            value = sprintf(formatspec,value);
        end
    end
    s.(name) =  json.struct(value);
elseif mandatory
    error('No value defined for non-optional property %s.%s',class(obj),name);
end

end

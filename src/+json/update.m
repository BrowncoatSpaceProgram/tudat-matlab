function s = update(s,obj,name,mandatory,formatSpec)

value = obj.(name);
if ~isempty(value)
    if nargin >= 5 && ~isempty(formatSpec)
        if iscell(value)
            for i = 1:length(value)
                value{i} = sprintf(formatSpec,value{i});
            end
        else
            value = sprintf(formatSpec,value);
        end
    end
    s.(name) =  json.struct(value);
else
    if nargin < 4
        mandatory = true;
    end
    if mandatory
        error('No value defined for non-optional property %s.%s',class(obj),name);
    end
end

end

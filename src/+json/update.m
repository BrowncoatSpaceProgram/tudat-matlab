function s = update(s,obj,name,mandatory)

value = obj.(name);
if ~isempty(value)
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

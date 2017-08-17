function s = struct(object)

if isstruct(object) && length(object) > 1
    object = num2cell(object);
end

if isstruct(object)  % struct -> std::map
    for key = fieldnames(object)'
        s.(key{1}) = json.struct(object.(key{1}));
    end
elseif iscell(object)  % cell -> std::vector
    s = object;
    for i = 1:length(object)
        s{i} = json.struct(object{i});
    end
else
    if any(strcmp(methods(object),'struct'))  % classdef -> class
        s = object.struct();
    else  % primitive -> int, double, bool, std::string OR classdef that can be directly converted to struct
        s = object;
    end
end

end

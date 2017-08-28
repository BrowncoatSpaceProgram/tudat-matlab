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
elseif isa(object,'containers.Map')  % containers.Map -> std::map
    keys = object.keys;
    for i = 1:length(keys)
        key = keys{i};
        if strcmp(object.KeyType,'char')
            s.(key) = json.struct(object(key));
        else
            s.(sprintf('CONVERTEDMAPKEY%g',key)) = json.struct(object(key));
        end
    end
else
    try  % classdef -> class
        s = object.struct();
    catch ME
        if strcmp(ME.identifier,'MATLAB:structRefFromNonStruct')  % primitive -> int, double, bool, std::string
            s = object;
        else
            rethrow(ME);
        end
    end
end

end

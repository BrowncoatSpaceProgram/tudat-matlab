function j = jsonize(object)

if isstruct(object) && length(object) > 1
    object = num2cell(object);
end

if isstruct(object)  % struct -> std::map
    for key = fieldnames(object)'
        j.(key{1}) = json.jsonize(object.(key{1}));
    end
elseif iscell(object)  % cell -> std::vector
    j = object;
    for i = 1:length(object)
        j{i} = json.jsonize(object{i});
    end
elseif isa(object,'containers.Map')  % containers.Map -> std::map
    j = containers.Map;
    keys = object.keys;
    for i = 1:length(keys)
        key = keys{i};
        if ~ischar(key)
            key = sprintf('%g',key);
        end
        j(key) = json.jsonize(object(keys{i}));
    end
else
    try  % classdef -> class
        j = object.jsonize();
    catch ME
        if isenum(object)  % enum -> std::string
            j = char(object);
        elseif strcmp(ME.identifier,'MATLAB:structRefFromNonStruct')  % primitive -> int, double, bool, string
            if isnumeric(object)
                if any(imag(object(:)))  % complex numbers -> "(real,imag")
                    [m,n] = size(object);
                    numobject = object;
                    if m == 1 && n == 1
                        object = sprintf('(%g,%g)',real(numobject),imag(numobject));
                    elseif m == 1 || n == 1
                        p = max(m,n);
                        object = cell(m,n);
                        for i = 1:p
                            object{i} = sprintf('(%g,%g)',real(numobject(i)),imag(numobject(i)));
                        end
                    else
                        object = cell(m,1);
                        for i = 1:m
                            for k = 1:n
                                object{i}{k} = sprintf('(%g,%g)',real(numobject(i,k)),imag(numobject(i,k)));
                            end
                        end
                    end
                end
            end
            j = object;
        else
            rethrow(ME);
        end
    end
end

end

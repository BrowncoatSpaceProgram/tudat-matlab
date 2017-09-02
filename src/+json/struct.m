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
    charMap = object;
    if ~strcmp(object.KeyType,'char')
        charMap = containers.Map;
        keys = object.keys;
        for i = 1:length(keys)
            key = keys{i};
            charMap(sprintf('%g',key)) = json.struct(object(key));
        end
    end
    s = charMap;
else
    try  % classdef -> class
        s = object.struct();
    catch ME
        if isenum(object)  % enum -> std::string
            s = char(object);
        elseif strcmp(ME.identifier,'MATLAB:structRefFromNonStruct')  % primitive -> int, double, bool, std::string
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
                            for j = 1:n
                                object{i}{j} = sprintf('(%g,%g)',real(numobject(i,j)),imag(numobject(i,j)));
                            end
                        end
                    end
                end
            end
            s = object;
        else
            rethrow(ME);
        end
    end
end

end

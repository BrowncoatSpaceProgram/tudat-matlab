function jsonObject = encode(object,tab)

if nargin < 2
    tab = 2;
end

% Convert to json (only if not json)
try
    object = jsondecode(object);
catch
end
jsonObject = strrep(jsonencode(json.struct(object)),'\','\\');

% Add indenting
if tab > 0
    indentedjson = [];
    indentLevel = 0;
    betweenQuotes = -1;
    for i = 1:length(jsonObject)
        c = jsonObject(i);
        if c == '"'
            betweenQuotes = -betweenQuotes;
        end
        if betweenQuotes == 1
            indentedjson = [indentedjson c];
        else
            if c == '{' || c == '['
                indentLevel = indentLevel + 1;
                indentedjson = [indentedjson c '\n'];
                for j = 1:(tab*indentLevel)
                    indentedjson = [indentedjson ' '];
                end
            elseif c == '}' || c == ']'
                indentLevel = indentLevel - 1;
                indentedjson = [indentedjson '\n'];
                for j = 1:(tab*indentLevel)
                    indentedjson = [indentedjson ' '];
                end
                indentedjson = [indentedjson c];
            elseif c == ','
                indentedjson = [indentedjson c '\n'];
                for j = 1:(tab*indentLevel)
                    indentedjson = [indentedjson ' '];
                end
            elseif c == ':'
                indentedjson = [indentedjson c ' '];
            else
                indentedjson = [indentedjson c];
            end
        end
    end
    jsonObject = indentedjson;
end

end

function jsonText = encode(object,tabsize)

if nargin < 2
    tabsize = 2;
end

% Deserialize (only if serialized)
try
    object = jsondecode(object);
catch
end

% Fix bug of jsonencode function when combined with sprintf/fprintf for escaped / and "
jsonText = strrep(strrep(jsonencode(json.jsonize(object)),'\/','/'),'\"','\\"');

% Add indenting
if tabsize > 0
    indentedjson = [];
    indentLevel = 0;
    betweenQuotes = -1;
    for i = 1:length(jsonText)
        c = jsonText(i);
        if c == '"'
            betweenQuotes = -betweenQuotes;
        end
        if betweenQuotes == 1
            indentedjson = sprintf('%s%s',indentedjson,c);
        else
            if c == '{' || c == '['
                indentLevel = indentLevel + 1;
                indentedjson = sprintf('%s%s\n',indentedjson,c);
                for j = 1:(tabsize*indentLevel)
                    indentedjson = sprintf('%s ',indentedjson);
                end
            elseif c == '}' || c == ']'
                indentLevel = indentLevel - 1;
                indentedjson = sprintf('%s\n',indentedjson);
                for j = 1:(tabsize*indentLevel)
                    indentedjson = sprintf('%s ',indentedjson);
                end
                indentedjson = sprintf('%s%s',indentedjson,c);
            elseif c == ','
                indentedjson = sprintf('%s%s\n',indentedjson,c);
                for j = 1:(tabsize*indentLevel)
                    indentedjson = sprintf('%s ',indentedjson);
                end
            elseif c == ':'
                indentedjson = sprintf('%s%s ',indentedjson,c);
            else
                indentedjson = sprintf('%s%s',indentedjson,c);
            end
        end
    end
    jsonText = indentedjson;
end

end

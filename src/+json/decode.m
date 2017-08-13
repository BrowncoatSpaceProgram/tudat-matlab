function struct = decode(json)
struct = jsondecode(strrep(json,'\n',''));
end

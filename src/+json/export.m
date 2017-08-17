function export(object,file,tab)

if nargin < 3
    tab = 2;
end

[~,filename,extension] = fileparts(file);
if isempty(filename) && isempty(extension)
    file = [file 'main.json'];
elseif isempty(filename) || isempty(extension)
    file = [file '.json'];
end

filesystem.createDirectories(fileparts(file));

fid = fopen(file,'w');
fprintf(fid,json.encode(object,tab));
fclose(fid);

end

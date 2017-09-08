function export(object,file,tabsize)

if nargin < 3
    tabsize = 2;
end

[~,filename,extension] = fileparts(file);
if isempty(filename) && isempty(extension)
    file = [file 'main.json'];
elseif isempty(filename) || isempty(extension)
    file = [file '.json'];
end

exportdir = fileparts(file);
if ~isempty(exportdir)
    if exist(exportdir,'dir') ~= 7
        mkdir(exportdir);
    end
end

fid = fopen(file,'w');
fprintf(fid,json.encode(object,tabsize));
fclose(fid);

end

function export(object,file,tab)
[~,filename,extension] = fileparts(file);
if isempty(filename) && isempty(extension)
    file = [file 'main.json'];
elseif isempty(filename) || isempty(extension)
    file = [file '.json'];
end
[directory,~,~] = fileparts(file);
if ~isempty(directory)
    if exist(directory,'dir') ~= 7
        mkdir(directory);
    end
end
fid = fopen(file,'w');
if nargin < 3
    tab = 2;
end
fprintf(fid,json.encode(object,tab));
fclose(fid);
end

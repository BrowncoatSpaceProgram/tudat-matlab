function [status,result] = systemCommand(varargin)

paths = split(strrep(tudat.PATH,';',':'),':');
if isunix
    sep = ':';
else
    sep = ';';
end
newPath = getenv('PATH');
for i = 1:length(paths)
    path = paths{i};
    if ~isempty(path) && isempty(strfind(newPath,path))
        newPath = sprintf('%s%s%s',newPath,sep,path);
    end
end
setenv('PATH',newPath);

setenv('LD_LIBRARYl_PATH','');

if ~isempty(tudat.commandPrefix)
    if isunix
        sep = '; ';
    else
        sep = ' & ';
    end
    varargin{1} = [tudat.commandPrefix sep varargin{1}];
end

[status,result] = system(varargin{:});

end

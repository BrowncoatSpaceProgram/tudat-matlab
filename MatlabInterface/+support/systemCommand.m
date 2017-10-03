function [status,result] = systemCommand(varargin)

if ~isempty(tudat.PATH)
    currentPath = getenv('PATH');
    if isempty(strfind(currentPath,tudat.PATH))
        if isunix
            sep = ':';
        else
            sep = ';';
        end
        setenv('PATH',[currentPath sep tudat.PATH]);
    end
end

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

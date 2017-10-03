function [status,result] = systemCommand(varargin)

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

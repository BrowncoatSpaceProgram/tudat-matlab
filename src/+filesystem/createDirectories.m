function createDirectories(path)

if ~isempty(path)
    if exist(path,'dir') ~= 7
        mkdir(path);
    end
end

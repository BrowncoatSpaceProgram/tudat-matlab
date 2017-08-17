function makeHidden(path)

if ispc
    fileattrib(path,'h');
else
    [parentdir,stem,extension] = fileparts(path);
    if isempty(stem)
        error('Could not make path hidden');
    end
    if stem(1) ~= '.'
        movefile(path,fullfile(parentdir,['.' stem extension]));
    end
end

function deleteFile(file)

if exist(file,'file') == 2
    delete(file);
end

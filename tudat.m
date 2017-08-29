classdef tudat
    properties (Constant, Hidden)
        fileContainingBinPath = fullfile(fileparts(mfilename('fullpath')),'.tudatbinpath')
    end
    
    methods (Static)
        function load(forceReload)
            if nargin < 1
                forceReload = false;
            end
            srcdir = fullfile(fileparts(mfilename('fullpath')),'src');
            dirs = horzcat(srcdir,getNonPackageDirectories(srcdir,true));
            loadedpaths = regexp(path,pathsep,'split');
            for i = 1:length(dirs)
                loaded = any(strcmp(dirs{i},loadedpaths));
                if ~loaded || forceReload
                    addpath(dirs{i});
                end
            end
        end
        
        function locate(binPath)
            tudat.bin(binPath);
        end
        
        function path = bin(path)
            if nargin == 0  % get bin path
                if exist(tudat.fileContainingBinPath,'file') ~= 2
                    error(['Could not find Tudat binary.\n'...
                        'Call tudat.locate(''binaryPath'') from the Command Window before running simulations.\n'...
                        'You will NOT need to do this again the next time you launch MATLAB.'],'');
                end
                path = fileread(tudat.fileContainingBinPath);
            end
            if exist(path,'file') ~= 2
                error(['Tudat binary was not found at the specified path: "%s"\n'...
                    'Call tudat.locate(''binaryPath'') from the Command Window '...
                    'to update Tudat binary path.'],path);
            end
            if nargin == 1  % set bin path (permanent until set again)
                fid = fopen(tudat.fileContainingBinPath,'w');
                fprintf(fid,path);
                fclose(fid);
            end
        end
        
    end
    
end


function directories = getNonPackageDirectories(directory,recursive)

if nargin < 2
    recursive = false;
end

files = dir(directory);
dirs = files([files.isdir]);
dirnames = {dirs.name};
directories = {};
for i = 1:length(dirnames)
    if ~any(strcmp(dirnames{i}(1),{'+','.'}))
        directories{end+1} = fullfile(directory,dirnames{i});
        if recursive
            directories = horzcat(directories,getNonPackageDirectories(directories{end},true));
        end
    end
end

end

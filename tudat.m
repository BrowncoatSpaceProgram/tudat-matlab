classdef tudat
    properties(Constant,Hidden)
        fileContainingBinPath = fullfile(fileparts(mfilename('fullpath')),'.tudatbinpath')
    end
    
    methods(Static)
        function load()
            sourceDir = fullfile(fileparts(mfilename('fullpath')),'src');
            addpath(sourceDir);
            addpath(fullfile(sourceDir,'Acceleration'));
            addpath(fullfile(sourceDir,'Body'));
            addpath(fullfile(sourceDir,'Integrator'));
            addpath(fullfile(sourceDir,'Spice'));
            addpath(fullfile(sourceDir,'Propagator'));
            addpath(fullfile(sourceDir,'Result'));
            addpath(fullfile(sourceDir,'Variable'));
        end
        
        function locate(binPath)
            tudat.bin(binPath);
        end
        
        function path = bin(path)
            if exist(tudat.fileContainingBinPath,'file') ~= 2
                error(['Could not find Tudat binary.\n'...
                    'Call tudat.locate(''binaryPath'') from the Command Window before running simulations.\n'...
                    'You will NOT need to do this again the next time you launch MATLAB.'],'');
            end
            if nargin == 0  % get bin path
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

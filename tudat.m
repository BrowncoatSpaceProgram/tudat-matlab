classdef tudat
    properties (Constant, Hidden)
        rootdir = fileparts(mfilename('fullpath'))
        testsdir = fullfile(tudat.rootdir,'tests')
        settingsfile = fullfile(tudat.rootdir,'settings.mat')
        
        binaryPathKey = 'binaryPath'
        testsDirectoryPathKey = 'testsDirectoryPath'
        
        defaultBinaryPath = fullfile('tudatExampleApplications','satellitePropagatorExamples','bin','applications','tudat')
        defaultTestsDirectoryPath = fullfile('tudat','Tudat','External','JsonInterface','UnitTests')
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
        
        function find(bundlePath)
            tudat.findBinary(fullfile(bundlePath,tudat.defaultBinaryPath));
            tudat.findTests(fullfile(bundlePath,tudat.defaultTestsDirectoryPath));
        end
        
        function findBinary(binaryPath)
            tudat.binary(binaryPath);
        end
        
        function findTests(testsDirectoryPath)
            tudat.testsDirectory(testsDirectoryPath);
        end
        
        function test(varargin)
            clc;
            n = length(varargin);
            if n == 0  % run all tests
                testFiles = dir(fullfile(tudat.testsdir,'*.m'));
                testNames = {testFiles.name};
            else  % run specified tests
                testNames = varargin;
            end
            n = length(testNames);
            title = sprintf('Running %i test',n);
            if n > 1
                title = [title 's'];
            end
            filenamewidth = 0;
            for i = 1:n
                [~,filename,~] = fileparts(testNames{i});
                testNames{i} = filename;
                filenamewidth = max(filenamewidth,length(filename));
            end
            fprintf([title '\n']);
            separator = repmat('=',1,length(title));
            fprintf([separator '\n']);
            passed = {};
            addpath(tudat.testsdir);
            for i = 1:n
                testName = testNames{i};
                fprintf(sprintf('Test %%%ii/%%i   %%-%is     ',length(sprintf('%i',n)),filenamewidth),i,n,testName);
                try
                    tic;
                    evalc(sprintf('failures = %s',testName));
                    if failures
                        result = sprintf('*** FAILED (%i errors) ***',failures);
                    else
                        result = 'PASSED';
                        passed{end+1} = testName;
                    end
                catch
                    result = '*** ERROR ***';
                end
                fprintf('%-25s   [ %.3f s ]\n',result,toc);
            end
            fprintf([separator '\n\n']);
            p = length(passed);
            fprintf('%i of %i tests (%g%%) passed.\n',p,n,p/n*100);
            if p < n
                fprintf('%i tests failed:\n',n-p);
                for i = 1:n
                    if ~any(strcmp(testNames{i},passed))
                        fprintf('   %s\n',testNames{i});
                    end
                end
            end
            fprintf('\n');
        end
        
    end
    
    methods (Static, Hidden)
        function s = settings
            s = load(tudat.settingsfile);
        end
        
        function path = binary(path)
            if nargin == 0  % get binary path
                try
                    path = tudat.settings.(tudat.binaryPathKey);
                catch
                    error(['Could not find Tudat binary.\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.findBinary(''tudatBinaryPath'') from the Command Window before running simulations.\n'...
                        'You will NOT need to do this again the next time you launch MATLAB.'],'');
                end
                if exist(path,'file') ~= 2
                    error(['Tudat binary was not found at the specified path: "%s"\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.findBinary(''binaryPath'') from the Command Window '...
                        'to update Tudat binary path.'],path);
                end
            else  % set binary path
                updateSetting(tudat.binaryPathKey,path);
            end
        end
        
        function path = testsDirectory(path)
            if nargin == 0  % get tests directory path
                try
                    path = tudat.settings.(tudat.testsDirectoryPathKey);
                catch
                    error(['Could not find Tudat tests directory.\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.findTests(''testsPath'') from the Command Window before running simulations.\n'...
                        'You will NOT need to do this again the next time you launch MATLAB.'],'');
                end
                if exist(path,'dir') ~= 7
                    error(['Tudat tests directory was not found at the specified path: "%s"\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.findTests(''testsPath'') from the Command Window '...
                        'to update Tudat tests directory.'],path);
                end
            else  % set tests directory path
                updateSetting(tudat.testsDirectoryPathKey,path);
            end
        end
        
    end
    
end


function updateSetting(name,value)

eval(sprintf('%s = ''%s'';',name,value));
if exist(tudat.settingsfile,'file') == 2
    save(tudat.settingsfile,name,'-append');
else
    save(tudat.settingsfile,name);
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

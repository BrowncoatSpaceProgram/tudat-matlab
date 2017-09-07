classdef tudat
    properties (Constant, Hidden)
        rootdir = fileparts(mfilename('fullpath'))
        testsdir = fullfile(tudat.rootdir,'tests')
        settingsfile = fullfile(tudat.rootdir,'settings.mat')
        
        binaryPathKey = 'binaryPath'
        testsSourcesDirectoryPathKey = 'testsSourcesDirectoryPath'
        testsBinariesDirectoryPathKey = 'testsBinariesDirectoryPath'
        
        defaultBundlePath = fullfile(tudat.rootdir,'tudatBundle');
        defaultInBundleBinaryPath = fullfile('tudatExampleApplications','satellitePropagatorExamples','bin','applications','tudat')
        defaultInBundleTestsSourcesPath = fullfile('tudat','Tudat','External','JsonInterface','UnitTests')
        defaultInBundleTestsBinariesPath = fullfile('tudat','bin','unit_tests')
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
            tudat.binary(fullfile(bundlePath,tudat.defaultInBundleBinaryPath));
            tudat.testsSourcesDirectory(fullfile(bundlePath,tudat.defaultInBundleTestsSourcesPath));
            tudat.testsBinariesDirectory(fullfile(bundlePath,tudat.defaultInBundleTestsBinariesPath));
        end
        
        function test(varargin)
            t0 = tic;
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
                        result = sprintf('<strong>%-24s</strong>',sprintf('*** FAILED (%i errors)',failures));
                    else
                        result = sprintf('%-24s','PASSED');
                        passed{end+1} = testName;
                    end
                catch
                    result = sprintf('<strong>%-24s</strong>','*** ERROR');
                end
                fprintf('%s  [ %.3f s ]\n',result,toc);
            end
            fprintf([separator '\n']);
            p = length(passed);
            fprintf('Total elapsed time: %g s.\n\n%i of %i tests (%g%%) passed.\n',toc(t0),p,n,p/n*100);
            f = n - p;
            if f > 0
                if f == 1
                    ts = '';
                else
                    ts = 's';
                end
                fprintf('%i test%s failed:\n',f,ts);
                for i = 1:n
                    testName = testNames{i};
                    if ~any(strcmp(testName,passed))
                        fprintf('   * <a href="matlab: open(which(''%s.m''))">%s.m</a>\n',testName,testName);
                    end
                end
            end
            fprintf('\n');
        end
        
        function s = settings
            s = load(tudat.settingsfile);
        end
        
        function path = binary(path)
            if nargin == 0  % get binary path
                try
                    path = tudat.settings.(tudat.binaryPathKey);
                catch
                    error(['Could not find Tudat binary.\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.binary(''tudatBinaryPath'') from the Command Window before running simulations.\n'...
                        'You will NOT need to do this again the next time you launch MATLAB.'],'');
                end
                if exist(path,'file') ~= 2
                    error(['Tudat binary was not found at the specified path: "%s"\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.binary(''binaryPath'') from the Command Window '...
                        'to update Tudat binary path.'],path);
                end
            else  % set binary path
                updateSetting(tudat.binaryPathKey,path);
            end
        end
        
        function path = testsSourcesDirectory(path)
            if nargin == 0  % get tests sources directory path
                try
                    path = tudat.settings.(tudat.testsSourcesDirectoryPathKey);
                catch
                    error(['Could not find Tudat tests sources directory.\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.testsSourcesDirectory(''path'') from the Command Window before running simulations.\n'...
                        'You will NOT need to do this again the next time you launch MATLAB.'],'');
                end
                if exist(path,'dir') ~= 7
                    error(['Tudat tests sources directory was not found at the specified path: "%s"\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.testsSourcesDirectory(''path'') from the Command Window '...
                        'to update Tudat tests sources directory.'],path);
                end
            else  % set tests sources directory path
                updateSetting(tudat.testsSourcesDirectoryPathKey,path);
            end
        end
        
        function path = testsBinariesDirectory(path)
            if nargin == 0  % get tests binaries directory path
                try
                    path = tudat.settings.(tudat.testsBinariesDirectoryPathKey);
                catch
                    error(['Could not find Tudat tests binaries directory.\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.testsBinariesDirectory(''path'') from the Command Window before running simulations.\n'...
                        'You will NOT need to do this again the next time you launch MATLAB.'],'');
                end
                if exist(path,'dir') ~= 7
                    error(['Tudat tests binaries directory was not found at the specified path: "%s"\n'...
                        'Call tudat.find(''tudatBundlePath'') or tudat.testsBinariesDirectory(''path'') from the Command Window '...
                        'to update Tudat tests binaries directory.'],path);
                end
            else  % set tests binaries directory path
                updateSetting(tudat.testsBinariesDirectoryPathKey,path);
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

classdef tudat
    properties (Constant, Hidden)
        rootdir = fileparts(mfilename('fullpath'))
        srcdir = fullfile(tudat.rootdir,'src')
        testsdir = fullfile(tudat.rootdir,'tests')
        settingsfile = fullfile(tudat.rootdir,'settings.mat')
        
        bundlePathKey = 'bundlePath'
        binaryPathKey = 'binaryPath'
        testsSourcesDirectoryPathKey = 'testsSourcesDirectoryPath'
        testsBinariesDirectoryPathKey = 'testsBinariesDirectoryPath'
        
        defaultBundlePath = fileparts(tudat.rootdir);
        defaultInBundleBinaryPath = fullfile('tudat','bin','json_interface')
        defaultInBundleTestsSourcesPath = fullfile('tudat','Tudat','JsonInterface','UnitTests')
        defaultInBundleTestsBinariesPath = fullfile('tudat','bin','unit_tests')
        
        defaultBinaryPath = fullfile(tudat.defaultBundlePath,tudat.defaultInBundleBinaryPath)
        defaultTestsSourcesPath = fullfile(tudat.defaultBundlePath,tudat.defaultInBundleTestsSourcesPath)
        defaultTestsBinariesPath = fullfile(tudat.defaultBundlePath,tudat.defaultInBundleTestsBinariesPath)
    end
    
    methods (Static)
        function load(forceReload)
            if nargin < 1
                forceReload = false;
            end
            dirs = horzcat(tudat.srcdir,getNonPackageDirectories(tudat.srcdir,true));
            loadedpaths = regexp(path,pathsep,'split');
            for i = 1:length(dirs)
                loaded = any(strcmp(dirs{i},loadedpaths));
                if ~loaded || forceReload
                    addpath(dirs{i});
                end
            end
        end
        
        function find(bundlePath)
            tudat.bundle(bundlePath);
            tudat.binary(fullfile(bundlePath,tudat.defaultInBundleBinaryPath));
            tudat.testsSourcesDirectory(fullfile(bundlePath,tudat.defaultInBundleTestsSourcesPath));
            tudat.testsBinariesDirectory(fullfile(bundlePath,tudat.defaultInBundleTestsBinariesPath));
        end
        
        function s = settings
            s = load(tudat.settingsfile);
        end
        
        function varargout = bundle(path)
            if nargin == 0  % get
                try
                    varargout{1} = tudat.settings.(tudat.bundlePathKey);
                catch
                    varargout{1} = tudat.defaultBundlePath;
                end
            else  % set
                updateSetting(tudat.bundlePathKey,path);
            end
        end
        
        function varargout = binary(path)
            if nargin == 0  % get
                try
                    varargout{1} = tudat.settings.(tudat.binaryPathKey);
                catch
                    varargout{1} = tudat.defaultBinaryPath;
                end
            else  % set
                updateSetting(tudat.binaryPathKey,path);
            end
        end
        
        function varargout = testsSourcesDirectory(path)
            if nargin == 0  % get
                try
                    varargout{1} = tudat.settings.(tudat.testsSourcesDirectoryPathKey);
                catch
                    varargout{1} = tudat.defaultTestsSourcesPath;
                end
            else  % set
                updateSetting(tudat.testsSourcesDirectoryPathKey,path);
            end
        end
        
        function varargout = testsBinariesDirectory(path)
            if nargin == 0  % get
                try
                    varargout{1} = tudat.settings.(tudat.testsBinariesDirectoryPathKey);
                catch
                    varargout{1} = tudat.defaultTestsBinariesPath;
                end
            else  % set
                updateSetting(tudat.testsBinariesDirectoryPathKey,path);
            end
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
            testOutputs = cell(size(testNames));
            for i = 1:n
                testName = testNames{i};
                fprintf(sprintf('Test %%%ii/%%i   %%-%is     ',length(sprintf('%i',n)),filenamewidth),i,n,testName);
                try
                    tic;
                    evalc(sprintf('[failures,testOutputs{i}] = %s',testName));
                    if failures == 0
                        result = sprintf('%-24s','PASSED');
                        passed{end+1} = testName;
                    elseif failures == -1
                        result = sprintf('<strong>%-24s</strong>','*** TUDAT ERROR');
                    else
                        result = sprintf('<strong>%-24s</strong>',sprintf('*** FAILED (%i errors)',failures));
                    end
                catch
                    result = sprintf('<strong>%-24s</strong>','*** MATLAB ERROR');
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
                        testOutput = testOutputs{i};
                        issueURL = test.getIssueURL(['test_json_' testName],testOutput);
                        fprintf('   * <a href="matlab: open(which(''%s.m''))">%s.m</a>',testName,testName);
                        fprintf(' (<a href="matlab: web(''%s'',''-browser'')">open issue</a>)',issueURL);
                        fprintf('\n');
                    end
                end
            end
            fprintf('\n');
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

% Build the required targets for the Tudat-MATLAB interface.

% Build options
buildUnitTests = true;
runUnitTests = true;
concurrentJobs = 4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Do not edit beyond this line %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tudat.load();

builddir = fullfile(fileparts(tudat.bundle),'build-tudatBundle-matlabInterface');
target = 'json_interface';

cmakebin = '';
% Default location on make if not installed to path
if ismac
    cmakebin = '/Applications/CMake.app/Contents/bin/cmake';
end
sep = '';
if isunix || ismac
    sep = ';';
    % Try to get cmake from path (UNIX)
    [status, response] = support.systemCommand('which cmake');
    if status == 0
        cmakebin = strtrim(response);
    end
elseif ispc
    sep = ' &';
    % Try for Windows
    [status, response] = support.systemCommand('where cmake');
    if status == 0
        cmakebin = strtrim(response);
    end
end
if exist(cmakebin,'file') ~= 2
    cmakebin = input('Specify the absolute path to the cmake binary: ','s');
end

if exist(builddir,'dir') ~= 7
    mkdir(builddir);
end

command = [
    sprintf('cd "%s"%s ',builddir,sep)...
    sprintf('"%s" "%s"%s ',cmakebin,fullfile('..','tudatBundle'),sep)...
    sprintf('"%s" --build . --target %s -- -j%i',cmakebin,target,concurrentJobs)
    ];

if buildUnitTests
    testFiles = dir(fullfile(tudat.testsdir,'*.m'));
    testNames = {testFiles.name};
    for i = 1:length(testNames)
        testBinName = strrep(strrep(testNames{i},'.m',''),'unitTest',tudat.testsBinariesPrefix);
        command = sprintf('%s%s "%s" --build . --target %s -- -j%i',...
            command,sep,cmakebin,testBinName,concurrentJobs);
    end
end

status = support.systemCommand(command,'-echo');
if status ~= 0
    error('There was a problem during compilation. Try to build the targets manually.');
end

if runUnitTests
    tudat.test();
end

matlabrc;  % Reset MATLAB to its startup state

buildUnitTests = true;
runUnitTests = true;
concurrentJobs = 4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Do not edit beyond this line %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mdir = fileparts(mfilename('fullpath'));
builddir = fullfile(mdir,'build');
tudatTarget = 'tudat';
testsTargetsPrefix = 'test_json_';

cmakebin = '';
% Default location on make if not installed to path
if ismac
    cmakebin = '/Applications/CMake.app/Contents/bin/cmake';
end
if isunix || ismac
    % Try to get cmake from path (UNIX)
    [status, response] = system('which cmake');
    if status == 0
        cmakebin = strtrim(response);
    end
elseif ispc
    % Try for Windows
    [status, response] = system('where cmake');
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
    sprintf('cd %s; ',builddir)...
    sprintf('LD_LIBRARY_PATH= %s ../tudatBundle; ',cmakebin)...
    sprintf('LD_LIBRARY_PATH= %s --build . --target %s -- -j%i',cmakebin,tudatTarget,concurrentJobs)
    ];

if buildUnitTests
    testFiles = dir(fullfile(tudat.testsdir,'*.m'));
    testNames = {testFiles.name};
    for i = 1:length(testNames)
        testName = strrep(testNames{i},'.m','');
        command = sprintf('%s;LD_LIBRARY_PATH= %s --build . --target %s%s -- -j%i',...
            command,cmakebin,testsTargetsPrefix,testName,concurrentJobs);
    end
end

status = system(command);
if status ~= 0
    error('There was a problem during installation. Try to compile the targets manually.');
end

if runUnitTests
    tudat.test();
end

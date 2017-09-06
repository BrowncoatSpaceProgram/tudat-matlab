clear all;

enableTesting = true;

tudatTarget = 'tudat';
testsTargetsPrefix = 'test_json_';

mdir = fileparts(mfilename('fullpath'));
cmakebin = '';
if ismac
    cmakebin = '/Applications/CMake.app/Contents/bin/cmake';
end
if exist(cmakebin,'file') ~= 2
    cmakebin = input('Specify the absolute path to the cmake binary: ','s');
end

command = [
    sprintf('cd %s; ',mdir)...
    'git clone https://github.com/aleixpinardell/tudatBundle.git; '...
    'cd tudatBundle; '...
    'git checkout json; '...
    'git submodule update --init --recursive; '...
    'cd ../; '...
    'mkdir build; '...
    'cd build; '...
    sprintf('%s ../tudatBundle; ',cmakebin)...
    sprintf('make -j4 %s',tudatTarget)
    ];

if enableTesting
    testFiles = dir(fullfile(tudat.testsdir,'*.m'));
    testNames = {testFiles.name};
    for i = 1:length(testNames)
        testName = strrep(testNames{i},'.m','');
        command = [command ' ' testsTargetsPrefix testName];
    end
end

status = system(command);

if status == 0
    run('quickSetup.m');
else
    error('There was a problem during installation.\nTry to compile the target %s manually and the run the MATLAB script quickSetup.m',tudatTarget);
end

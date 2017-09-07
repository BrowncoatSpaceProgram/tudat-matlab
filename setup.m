matlabrc;  % Reset MATLAB to its startup state

enableUnitTests = true;
maximumNumberOfConcurrentJobsDuringBuild = 4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Do not edit beyond this line %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mdir = fileparts(mfilename('fullpath'));
addpath(mdir);
savepath;

tudatBundleDirectory = input('Specify the path to the tudatBundle directory (or press intro to use default path): ','s');
if ~isempty(tudatBundleDirectory)
    tudat.find(tudatBundleDirectory);
else
    tudat.find(tudat.defaultBundlePath);

    tudatTarget = 'tudat';
    testsTargetsPrefix = 'test_json_';
    
    cmakebin = '';
    if ismac
        cmakebin = '/Applications/CMake.app/Contents/bin/cmake';
    end
    if exist(cmakebin,'file') ~= 2
        cmakebin = input('Specify the absolute path to the cmake binary: ','s');
    end
    
    command = [
        sprintf('cd %s; ',mdir)...
        'git pull; '...
        'git clone https://github.com/aleixpinardell/tudatBundle.git; '...
        'cd tudatBundle; '...
        'git checkout json; '...
        'git pull; '...
        'git submodule update --init --recursive; '...
        'git submodule update --recursive; '...
        'cd ../; '...
        'mkdir build; '...
        'cd build; '...
        sprintf('%s ../tudatBundle; ',cmakebin)...
        sprintf('make -j%i %s',maximumNumberOfConcurrentJobsDuringBuild,tudatTarget)
        ];
    
    if enableUnitTests
        testFiles = dir(fullfile(tudat.testsdir,'*.m'));
        testNames = {testFiles.name};
        for i = 1:length(testNames)
            testName = strrep(testNames{i},'.m','');
            command = [command ' ' testsTargetsPrefix testName];
        end
    end
    
    status = system(command);
    if status ~= 0
        error('There was a problem during installation. Try to compile the target %s manually.',tudatTarget);
    end
end

if enableUnitTests
    tudat.test();
end

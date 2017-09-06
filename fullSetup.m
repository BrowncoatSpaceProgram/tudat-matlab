clear all;

enableTesting = true;

cmakebin = input('Specify the path to cmake: ','s');
mdir = fileparts(mfilename('fullpath'));

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
    'make -j4 tudat' ];

if enableTesting
    testfiles = dir(fullfile(tudat.testsdir,'*.m'));
    testnames = {testfiles.name}
    for i = 1:length(testnames)
        testname = strrep(testnames{i},'.m','');
        command = [command ' test_json_' testname];
    end
end

system(command);

run('quicksetup.m');

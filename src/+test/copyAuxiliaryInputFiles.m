function copyAuxiliaryInputFiles(testPath)

[testsDir,testName,~] = fileparts(testPath);
testAuxDir = fullfile(testsDir,'auxinput',testName);
files = dir(testAuxDir);
files = files(~ismember({files.name},{'.','..'}));
filenames = {files.name};

for i = 1:length(filenames)
    sourceFile = fullfile(testAuxDir,filenames{i});
    targetFile = fullfile(tudat.testsSourcesDirectory,'INPUT',testName,filenames{i});
    copyfile(sourceFile,targetFile);
end

end

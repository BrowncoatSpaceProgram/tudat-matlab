function failcount = runUnitTest(testName)

failcount = 0;
[~,output] = system(fullfile(tudat.testsBinariesDirectory,['test_json_' testName]),'-echo');
[~,tok] = regexp(output,'\*\*\* (\d+)','match','tokens');
if ~isempty(tok)
    failcount = str2double(tok{1}{1});
end

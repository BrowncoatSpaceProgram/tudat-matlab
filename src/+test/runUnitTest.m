function failcount = runUnitTest(testName)

failcount = 0;
[status,output] = system(fullfile(tudat.testsBinariesDirectory,['test_json_' testName]),'-echo');
[~,tok] = regexp(output,'\*\*\* (\d+) failure','match','tokens');
if ~isempty(tok)
    failcount = str2double(tok{1}{1});
elseif status
    error('Terminated with status: %g',status);
end

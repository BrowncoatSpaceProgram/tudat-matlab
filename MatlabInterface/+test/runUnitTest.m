function [failCount,testOutput] = runUnitTest(testName)

failCount = 0;
testNameFull = strrep(testName,'unitTest',tudat.testsBinariesPrefix);
[status,testOutput] = system(['LD_LIBRARY_PATH= "' fullfile(tudat.testsBinariesDirectory,testNameFull) '"'],'-echo');
[~,tok] = regexp(testOutput,'\*\*\* (\d+) failure','match','tokens');
if ~isempty(tok)
    failCount = str2double(tok{1}{1});
elseif status ~= 0
    failCount = -1;
end

if failCount ~= 0
    fprintf('\nPlease, <a href="matlab: web(''%s'',''-browser'')">open an issue on GitHub</a>.\n',...
        test.getIssueURL(testNameFull,testOutput));
end

end

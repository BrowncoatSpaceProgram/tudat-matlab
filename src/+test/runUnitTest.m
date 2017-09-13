function [failcount,issueURL] = runUnitTest(testName)

failcount = 0;
testNameFull = ['test_json_' testName];
[status,output] = system(['LD_LIBRARY_PATH= ' fullfile(tudat.testsBinariesDirectory,testNameFull)],'-echo');
[~,tok] = regexp(output,'\*\*\* (\d+) failure','match','tokens');
if ~isempty(tok)
    failcount = str2double(tok{1}{1});
elseif status ~= 0
    failcount = -1;
end

if failcount == 0
    issueURL = '';
else
    issueTitle = sprintf('%s failing',testNameFull);
    issueBody = '';
    if ~isempty(output)
        issueBody = sprintf('```%s```',output);
    end
    issueURL = sprintf('http://github.com/Tudat/tudat/issues/new?title=%s&body=%s',...
        urlencode(issueTitle),urlencode(issueBody));
    fprintf('\nPlease, <a href="matlab: web(''%s'',''-browser'')">open an issue on GitHub</a>.\n',issueURL)
end

end

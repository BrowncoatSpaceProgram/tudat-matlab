function issueURL = getIssueURL(testName,testOutput)

issueTitle = sprintf('%s failing',testName);
issueBody = '';
if ~isempty(testOutput)
    issueBody = sprintf('```%s```',testOutput);
end
issueURL = sprintf('http://github.com/Tudat/tudat/issues/new?title=%s&body=%s',...
    urlencode(issueTitle),urlencode(issueBody));

end

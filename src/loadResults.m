function [results,propagationFailure] = loadResults(file)

results = importdata(file,' ');
propagationFailure = false;
if isstruct(results)
    try
        for i = 1:length(results.textdata)
            if strcmp(results.textdata{i},'FAILURE')
                propagationFailure = true;
                break;
            end
        end
    catch
    end
    results = results.data;
end

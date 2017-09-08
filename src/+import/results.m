function [res,propagationFailure] = results(file)

res = importdata(file,' ');
propagationFailure = false;
if isstruct(res)
    try
        for i = 1:length(res.textdata)
            if strcmp(res.textdata{i},'FAILURE')
                propagationFailure = true;
                break;
            end
        end
    catch
    end
    res = res.data;
end

end

function [res,propagationFailure] = results(file,warnOnFailure)

if nargin < 2
    warnOnFailure = '';
end

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

if propagationFailure && strcmpi(warnOnFailure,'warn')
    warning([sprintf('Propagation failed when generating file %s\n',file)...
        'Returning results until epoch of propagation failure.']);
end

end

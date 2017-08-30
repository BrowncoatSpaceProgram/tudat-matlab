function createInput(object,filename,jsonize)

if nargin < 3
    jsonize = true;
end

filepath = fullfile(tudat.testsSourcesDirectory,'inputs',filename);
if jsonize
    json.export(object,filepath);
else
    fid = fopen(filepath,'w');
    fprintf(fid,object);
    fclose(fid);
end

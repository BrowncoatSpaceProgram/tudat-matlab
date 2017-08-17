function map = loadMap(file,varargin)

keyType = support.optionalArgument('char','KeyType',varargin);
keyFormat = support.optionalArgument('%g','KeyFormat',varargin);

matrix = load(file);
map = containers.Map('KeyType',keyType,'ValueType','any');
for i = 1:length(matrix)
    key = matrix(i,1);
    if strcmp(keyType,'char')
        key = sprintf(keyFormat,key);
    end
    map(key) = matrix(i,2:end);
end

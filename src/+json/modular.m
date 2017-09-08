function object = modular(object,file,tabsize)

if nargin < 3
    tabsize = 2;
end
json.export(object,file,tabsize);
object = ['$(' file ')'];

end

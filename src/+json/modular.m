function object = modular(object,file,tab)
if nargin < 3
    tab = 2;
end
json.export(object,file,tab);
object = ['$(' file ')'];
end

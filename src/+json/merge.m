function array = merge(object,varargin)

N = length(varargin);
if mod(N,2) ~= 0
    error('You must provide an odd number of input arguments: object, key1, value1, key2, value2...');
end

map = containers.Map;
for i = 1:2:N
    map(varargin{i}) = varargin{i+1};
end

array = { object, map };

end

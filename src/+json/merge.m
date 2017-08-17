function array = merge(object,varargin)

N = length(varargin);
if mod(N,2) ~= 0
    error('You must provide an odd number of input arguments: object, key1, value1, key2, value2...');
end

map = containers.Map;
for i = 1:N/2
    map(varargin{2*i-1}) = varargin{2*i};
end

array = { object, map };

end

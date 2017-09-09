function val = optionalArgument(arguments,name,default)

val = default;
N = length(arguments);
assert(mod(N,2) == 0,'One of the optional arguments names does not have an associated value.');
for i = 1:2:N
    if strcmpi(name,arguments{i})
        val = arguments{i+1};
    end
end

end

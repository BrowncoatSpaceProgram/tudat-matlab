function current = printProgress(current,previous,bar,precision)

if nargin < 4
    precision = 0;
end

if nargin < 3
    bar = 0;
end

currentStr = sprintf(sprintf('%%.%if%%%%',precision),current*100);

if nargin < 2
    updateProgress = 1;
else
    previousStr = sprintf(sprintf('%%.%if%%%%',precision),previous*100);
    updateProgress = ~strcmp(currentStr,previousStr);
end

if updateProgress
    output = '';
    if bar
        full = round(current*100);
        for i = 1:full
            output = sprintf('%s\x25FC',output);
        end
        for i = (full+1):100
            output = sprintf('%s\x25FB',output);
        end
        output = sprintf('%s\n',output);
        for i = 1:round((100-length(currentStr))/2)
            output = sprintf('%s ',output);
        end
    end
    output = sprintf('%s%s\n',output,currentStr);
    clc; fprintf('%s',output);
end

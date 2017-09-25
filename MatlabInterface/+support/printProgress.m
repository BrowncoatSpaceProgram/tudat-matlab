function current = printProgress(current,previous,timer,bar,precision)

if nargin < 5
    precision = 0;
    if nargin < 4
        bar = true;
        if nargin < 3
            timer = [];
        end
    end
end

currentStr = sprintf(sprintf('%%.%if%%%%',precision),current*100);

if nargin < 2
    updateProgress = 1;
else
    previousStr = sprintf(sprintf('%%.%if%%%%',precision),previous*100);
    updateProgress = ~strcmp(currentStr,previousStr);
end

if updateProgress
    if ~isempty(timer) && current > 0
        timeRemaining = toc(timer)/current*(1 - current);
        units = {'s','min','h','d'};
        times = zeros(size(units));
        for i = 1:length(units)
            times(i) = convert.fromSI(timeRemaining,units{i});
        end
        i = find(times>1,1,'last');
        if isempty(i)
            i = 1;
        end
        currentStr = [currentStr sprintf(' (%i %s remaining)',round(times(i)),units{i})];
    end
    
    output = '';
    if bar
        full = floor(current*100);
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

end

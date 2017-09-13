matlabrc;  % Reset MATLAB to its startup state

mdir = fileparts(mfilename('fullpath'));
addpath(mdir);
if exist(userpath,'dir') == 7
    savepath(fullfile(userpath,'pathdef.m'));
else
    savepath;
end

run('build.m');

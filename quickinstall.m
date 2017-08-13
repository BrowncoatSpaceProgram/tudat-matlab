[tudatmatlabdir,~,~] = fileparts(mfilename('fullpath'));
addpath(tudatmatlabdir);
savepath;
tudat.locate(input('Specify the path to the Tudat binary: ','s'));
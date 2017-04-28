[token, remain] = strtok(fliplr(mfilename('fullpath')), '\');
folder = fliplr(remain);
addpath([ folder 'GUI auxiliary']);
addpath([ folder 'Cyrus auxiliary']);
cd(folder);
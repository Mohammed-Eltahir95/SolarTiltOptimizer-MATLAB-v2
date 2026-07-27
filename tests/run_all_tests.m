root=fileparts(fileparts(mfilename('fullpath')));addpath(fullfile(root,'src'));results=runtests(fullfile(root,'tests'),'IncludeSubfolders',true);assertSuccess(results);disp(results)


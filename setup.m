function setup()
%SETUP Add project source code to the MATLAB path.
root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, 'src'));
fprintf('SolarTiltOptimizer is ready. Run run_project.m to start.\n');
end


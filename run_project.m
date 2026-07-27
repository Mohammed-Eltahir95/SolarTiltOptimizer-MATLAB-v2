%% SolarTiltOptimizer-MATLAB demonstration entry point
% Downloads or imports weather data, runs all configured transposition
% models, stores reproducible results, and writes reports and figures.
root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, 'src'));
config = solartilt.loadConfig(fullfile(root, 'config', 'sudan_example.json'));
results = solartilt.runStudy(config);
disp(results.summary)


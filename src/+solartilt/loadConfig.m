function config = loadConfig(path)
%LOADCONFIG Read and validate a JSON study configuration.
arguments, path (1,1) string, end
config = jsondecode(fileread(path));
required = {'studyName','dataSource','locations','models','optimization','output'};
assert(all(isfield(config, required)), 'SolarTilt:InvalidConfig', ...
    'Configuration is missing one or more required sections.');
assert(~isempty(config.locations), 'SolarTilt:InvalidConfig', 'At least one location is required.');
validModels = ["LiuJordan","Badescu","Klucher","Perez","HayDavies","HDKR","Koronakis","TempsCoulson"];
assert(all(ismember(string(config.models), validModels)), 'SolarTilt:InvalidModel', 'Unknown model in configuration.');
config.projectRoot = fileparts(fileparts(path));
config.output.directory = resolve(config.projectRoot, config.output.directory);
config.output.database = resolve(config.projectRoot, config.output.database);
end

function p = resolve(root, p)
p = string(p);
if ~startsWith(p, filesep) && isempty(regexp(p, '^[A-Za-z]:[\\/]', 'once'))
    p = fullfile(root, p);
end
end


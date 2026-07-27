function db=open(path)
folder=fileparts(path);if ~isfolder(folder),mkdir(folder);end
assert(exist('sqlite','file')==2,'SolarTilt:SQLiteUnavailable','MATLAB sqlite support is required; see REQUIREMENTS.md.');
db=sqlite(path,'create');solartilt.db.initialize(db);
end


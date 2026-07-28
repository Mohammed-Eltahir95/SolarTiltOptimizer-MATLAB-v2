function db=open(path)
if exist('sqlite','file')~=2
    warning('SolarTilt:SQLiteUnavailable', ...
        ['MATLAB sqlite support is unavailable. Continuing without the ' ...
         'weather cache or results database; CSV files and figures are unaffected.']);
    db=[];
    return
end
folder=fileparts(path);if ~isfolder(folder),mkdir(folder);end
db=sqlite(path,'create');solartilt.db.initialize(db);
end


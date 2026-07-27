function closeConnection(db)
%CLOSECONNECTION Close a SQLite connection.
if ~isempty(db), close(db); end
end

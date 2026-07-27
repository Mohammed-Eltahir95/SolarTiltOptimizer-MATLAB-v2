function id=beginRun(db,config)
id=string(char(java.util.UUID.randomUUID));stamp=char(datetime('now','TimeZone','UTC','Format','yyyy-MM-dd''T''HH:mm:ssXXX'));insert(db,'study_runs',{'run_id','started_at','status','config_json'},{char(id),stamp,'running',jsonencode(config)});
end


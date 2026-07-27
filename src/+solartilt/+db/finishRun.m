function finishRun(db,id,status)
stamp=char(datetime('now','TimeZone','UTC','Format','yyyy-MM-dd''T''HH:mm:ssXXX'));exec(db,sprintf("UPDATE study_runs SET finished_at='%s', status='%s' WHERE run_id='%s'",stamp,status,id));
end


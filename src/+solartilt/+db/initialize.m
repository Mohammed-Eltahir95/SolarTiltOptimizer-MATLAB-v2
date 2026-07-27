function initialize(db)
exec(db,'CREATE TABLE IF NOT EXISTS study_runs (run_id TEXT PRIMARY KEY, started_at TEXT, finished_at TEXT, status TEXT, config_json TEXT)');
exec(db,'CREATE TABLE IF NOT EXISTS datasets (cache_key TEXT PRIMARY KEY, provenance_json TEXT, weather_json TEXT, retrieved_at TEXT)');
exec(db,'CREATE TABLE IF NOT EXISTS results (run_id TEXT, result_type TEXT, payload_json TEXT, FOREIGN KEY(run_id) REFERENCES study_runs(run_id))');
end


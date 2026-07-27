function storeWeather(db,weather,provenance)
if ~isfield(provenance,'cacheKey'),return,end;key=char(provenance.cacheKey);exec(db,sprintf("DELETE FROM datasets WHERE cache_key='%s'",key));insert(db,'datasets',{'cache_key','provenance_json','weather_json','retrieved_at'},{key,jsonencode(provenance),jsonencode(table2struct(weather)),char(provenance.retrievedAt)});
end


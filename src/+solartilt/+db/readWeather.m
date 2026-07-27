function out=readWeather(db,key)
rows=fetch(db,sprintf("SELECT provenance_json, weather_json FROM datasets WHERE cache_key='%s'",key));out=[];if isempty(rows),return,end
if istable(rows),p=rows{1,1};w=rows{1,2};else,p=rows{1};w=rows{2};end;provenance=jsondecode(p);weather=struct2table(jsondecode(w));weather.timestamp=datetime(string(weather.timestamp),'TimeZone','UTC');out=struct('weather',weather,'provenance',provenance);
end


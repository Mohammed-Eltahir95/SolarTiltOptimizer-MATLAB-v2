function [weather,provenance]=importFile(path,location)
t=readtable(path); t.Properties.VariableNames=lower(string(t.Properties.VariableNames));
aliases=struct('time','timestamp','t2m','temperature','ws10m','wind_speed','rh','relative_humidity','sp','pressure','long','longitude'); fields=fieldnames(aliases);
for k=1:numel(fields),old=fields{k};new=aliases.(old);if ismember(old,t.Properties.VariableNames)&&~ismember(new,t.Properties.VariableNames),t.Properties.VariableNames(t.Properties.VariableNames==old)=new;end,end
assert(all(ismember(["timestamp","ghi","dhi","dni"],t.Properties.VariableNames)),'SolarTilt:Schema','Required columns: timestamp, ghi, dhi, dni.');
if ~isdatetime(t.timestamp),try,t.timestamp=datetime(string(t.timestamp),'TimeZone','UTC');catch,t.timestamp=datetime(string(t.timestamp),'InputFormat','yyyyMMdd:HHmm','TimeZone','UTC');end;elseif isempty(t.timestamp.TimeZone),t.timestamp.TimeZone='UTC';end
keep=intersect(["timestamp","latitude","longitude","ghi","dni","dhi","temperature","wind_speed","pressure","relative_humidity","source","quality_flag"],t.Properties.VariableNames,'stable');weather=t(:,keep);n=height(weather);
if ~ismember('latitude',weather.Properties.VariableNames),weather.latitude=repmat(location.latitude,n,1);end;if ~ismember('longitude',weather.Properties.VariableNames),weather.longitude=repmat(location.longitude,n,1);end
provenance=struct('sourceType','file','sourceUri',string(path),'dataset','user-supplied','retrievedAt',datetime('now','TimeZone','UTC'),'locationName',string(location.name));
end


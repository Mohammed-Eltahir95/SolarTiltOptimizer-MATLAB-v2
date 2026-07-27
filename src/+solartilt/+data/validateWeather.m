function validateWeather(t)
assert(all(ismember({'timestamp','latitude','longitude','ghi','dhi','dni'},t.Properties.VariableNames)),'SolarTilt:Schema','Weather table does not match the canonical schema.');
assert(issorted(t.timestamp)&&numel(unique(t.timestamp))==height(t),'SolarTilt:Time','Timestamps must be unique and ascending.');
assert(all(isfinite(t.latitude))&&all(isfinite(t.longitude)),'SolarTilt:Coordinates','Coordinates must be finite.');
end


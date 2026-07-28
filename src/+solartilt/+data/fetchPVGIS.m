function [weather,provenance]=fetchPVGIS(source,location,db)
key=solartilt.data.cacheKey(source,location);cached=solartilt.db.readWeather(db,key);if ~source.forceRefresh&&~isempty(cached),weather=cached.weather;provenance=cached.provenance;return,end
base=strip(string(source.apiBaseUrl),'right','/');product=lower(string(source.product));params={'lat',location.latitude,'lon',location.longitude,'startyear',source.startYear,'endyear',source.endYear,'usehorizon',double(source.useHorizon),'outputformat','json'};
if product=="hourly",endpoint=base+"/seriescalc";params=[params {'raddatabase',source.radiationDatabase,'components',1,'angle',0,'aspect',0,'pvcalculation',0}];elseif product=="tmy",endpoint=base+"/tmy";else,error('SolarTilt:PVGISProduct','PVGIS product must be hourly or tmy.');end
raw=webread(endpoint,params{:},weboptions('Timeout',120,'ContentType','json'));
irradianceTimeOffsetHours=0;
dataset=string(source.radiationDatabase);
if product=="hourly"
    rows=raw.outputs.hourly;
else
    rows=raw.outputs.tmy_hourly;
    if isfield(raw,'inputs')&&isfield(raw.inputs,'location')&&isfield(raw.inputs.location,'irradiance_time_offset')
        irradianceTimeOffsetHours=double(raw.inputs.location.irradiance_time_offset);
    end
    if isfield(raw,'inputs')&&isfield(raw.inputs,'meteo_data')&&isfield(raw.inputs.meteo_data,'radiation_db')
        dataset=string(raw.inputs.meteo_data.radiation_db);
    end
end
weather=solartilt.data.normalizePVGIS(rows,location,irradianceTimeOffsetHours,product=="tmy");
provenance=struct('cacheKey',key,'sourceType','PVGIS','sourceUri',endpoint,'apiVersion','5.3','dataset',dataset,'product',product,'startYear',source.startYear,'endYear',source.endYear,'irradianceTimeOffsetHours',irradianceTimeOffsetHours,'retrievedAt',datetime('now','TimeZone','UTC'),'locationName',string(location.name));
end

function [weather,provenance]=loadWeather(source,location,db)
switch lower(source.type)
 case 'pvgis',[weather,provenance]=solartilt.data.fetchPVGIS(source,location,db);
 case {'csv','excel','xlsx'},[weather,provenance]=solartilt.data.importFile(source.path,location);
 otherwise,error('SolarTilt:DataSource','Unsupported data source: %s',source.type)
end
end


function t=normalizePVGIS(rows,location)
if isstruct(rows),raw=struct2table(rows);else,raw=rows;end;names=lower(regexprep(string(raw.Properties.VariableNames),'[^A-Za-z0-9]',''));
time=pick(raw,names,"time");ghi=pick(raw,names,["gh","gi","g"]);dhi=pick(raw,names,["gdh","gdi"]);dni=pick(raw,names,["gbn","dni"],false);bh=pick(raw,names,["gbh","gbi"],false);sun=pick(raw,names,"hsun",false);
if isempty(dni),assert(~isempty(bh)&&~isempty(sun),'SolarTilt:PVGISSchema','Cannot derive DNI.');dni=bh./max(sind(sun),1e-6);dni(sun<=0)=0;end
timestamp=datetime(string(time),'InputFormat','yyyyMMdd:HHmm','TimeZone','UTC');n=numel(timestamp);t=table(timestamp,repmat(location.latitude,n,1),repmat(location.longitude,n,1),double(ghi),double(dni),double(dhi),'VariableNames',{'timestamp','latitude','longitude','ghi','dni','dhi'});t=sortrows(t,'timestamp');
end
function v=pick(raw,names,candidates,required)
if nargin<4,required=true;end;idx=find(ismember(names,candidates),1);if isempty(idx),if required,error('SolarTilt:PVGISSchema','Missing PVGIS response field.');else,v=[];return,end,end;v=raw.(raw.Properties.VariableNames{idx});
end


function [annual,monthly,seasonal,statistics]=summarize(r,location)
annual=table(); monthly=table(); seasonal=table(); statistics=table();
[~,latIdx]=min(abs(r.betaGrid-r.latitudeTilt));
perezMonthly=[]; if isfield(r.models,'Perez'), p=r.models.Perez; perezMonthly=periodEnergy(p.poa,p.monthlyIndex,r.months,12,r.dtHours); end
for k=1:numel(r.modelNames)
 name=r.modelNames(k); x=r.models.(char(name)); eOpt=sum(x.poa(:,x.annualIndex).*r.dtHours,'omitnan')/1000; eLat=sum(x.poa(:,latIdx).*r.dtHours,'omitnan')/1000;
 annual=[annual;table(string(location.name),name,location.latitude,location.longitude,r.betaGrid(latIdx),x.annualTilt,eOpt,eLat,eOpt-eLat,100*(eOpt-eLat)/max(eLat,1e-9),'VariableNames',{'Location','Model','Latitude_deg','Longitude_deg','LatitudeTilt_deg','OptimalTilt_deg','OptimalEnergy_kWhm2','LatitudeEnergy_kWhm2','Gain_kWhm2','Gain_pct'})]; %#ok<AGROW>
 em=periodEnergy(x.poa,x.monthlyIndex,r.months,12,r.dtHours); elm=periodEnergy(x.poa,repmat(latIdx,12,1),r.months,12,r.dtHours);
 monthly=[monthly;table(repmat(string(location.name),12,1),repmat(name,12,1),(1:12)',x.monthlyTilt,em,elm,em-elm,100*(em-elm)./max(elm,1e-9),'VariableNames',{'Location','Model','Month','OptimalTilt_deg','OptimalEnergy_kWhm2','LatitudeEnergy_kWhm2','Gain_kWhm2','Gain_pct'})]; %#ok<AGROW>
 es=periodEnergy(x.poa,x.seasonalIndex,r.seasons,4,r.dtHours); els=periodEnergy(x.poa,repmat(latIdx,4,1),r.seasons,4,r.dtHours);
 seasonal=[seasonal;table(repmat(string(location.name),4,1),repmat(name,4,1),["DJF";"MAM";"JJA";"SON"],x.seasonalTilt,es,els,es-els,100*(es-els)./max(els,1e-9),'VariableNames',{'Location','Model','Season','OptimalTilt_deg','OptimalEnergy_kWhm2','LatitudeEnergy_kWhm2','Gain_kWhm2','Gain_pct'})]; %#ok<AGROW>
 if ~isempty(perezMonthly), err=em-perezMonthly; mbe=mean(err,'omitnan'); rmse=sqrt(mean(err.^2,'omitnan')); mae=mean(abs(err),'omitnan'); mape=100*mean(abs(err)./max(perezMonthly,1e-9),'omitnan'); r2=1-sum((perezMonthly-em).^2,'omitnan')/max(sum((perezMonthly-mean(perezMonthly,'omitnan')).^2,'omitnan'),1e-12); statistics=[statistics;table(string(location.name),name,mbe,rmse,mae,mape,r2,'VariableNames',{'Location','Model','MBE_kWhm2','RMSE_kWhm2','MAE_kWhm2','MAPE_pct','R2'})]; end %#ok<AGROW>
end
end
function e=periodEnergy(poa,idx,p,n,dt)
e=zeros(n,1); for i=1:n, q=p==i; e(i)=sum(poa(q,idx(i)).*dt(q),'omitnan')/1000; end
end


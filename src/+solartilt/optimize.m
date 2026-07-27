function result = optimize(weather, location, modelList, options)
%OPTIMIZE Preserve the original exhaustive 0:1:90-degree optimization.
arguments
    weather table
    location (1,1) struct
    modelList
    options (1,1) struct
end
Time=weather.timestamp; GHI=weather.ghi; DHI=weather.dhi; DNI=weather.dni;
gridSpec=options.tiltGridDeg; betaGrid=(gridSpec(1):gridSpec(3):gridSpec(2))';
dt_h=hours([diff(Time); Time(end)-Time(end-1)]);
bad=dt_h<=0 | isnan(dt_h); dt_h(bad)=median(dt_h(~bad));
[zen,saz,E0]=solartilt.solarPosition(Time,location.latitude,location.longitude,location.elevation);
sunUp=cosd(zen)>options.sunThreshold;
GHI=max(GHI,0); DHI=max(DHI,0); DNI=max(DNI,0);
GHI(~isfinite(GHI))=0; DHI(~isfinite(DHI))=0; DNI(~isfinite(DNI))=0;
DHI=min(DHI,GHI); GHI(~sunUp)=0; DHI(~sunUp)=0; DNI(~sunUp)=0;
e=options.epsilonIrradiance;
GHI(sunUp&GHI==0)=e; DHI(sunUp&DHI==0)=e; DNI(sunUp&DNI==0)=e;
cosZ=cosd(zen); sinZ=sind(zen); cosZsafe=max(cosZ,1e-6);
beta=betaGrid'; cb=cosd(beta); sb=sind(beta);
cosInc=max(cosZ.*cb+(sinZ.*sb).*cosd(saz-options.surfaceAzimuthDeg),0);
beam=DNI.*cosInc; ground=(GHI.*options.albedo).*(1-cb)/2;
Kt=min(max(GHI./(E0.*cosZsafe),0),2); AI=min(max(DNI./max(E0,1e-6),0),1.5);
common=struct('GHI',GHI,'DHI',DHI,'DNI',DNI,'E0',E0,'Kt',Kt,'AI',AI, ...
    'Fd',(1+cb)/2,'cosInc',cosInc,'cosZ',cosZsafe,'BHI',DNI.*cosZ,'zen',zen);
months=month(Time); seasons=solartilt.seasonId(months); models=struct();
for i=1:numel(modelList)
    name=char(modelList{i}); diffuse=solartilt.transposeDiffuse(name,betaGrid,common);
    poa=max(beam+diffuse+ground,0); poa(~isfinite(poa))=0;
    annualEnergy=sum(poa.*dt_h,1,'omitnan'); [~,iy]=max(annualEnergy);
    im=zeros(12,1); is=zeros(4,1);
    for mo=1:12, [~,im(mo)]=max(sum(poa(months==mo,:).*dt_h(months==mo),1,'omitnan')); end
    for se=1:4, [~,is(se)]=max(sum(poa(seasons==se,:).*dt_h(seasons==se),1,'omitnan')); end
    models.(name)=struct('poa',poa,'annualIndex',iy,'monthlyIndex',im,'seasonalIndex',is, ...
        'annualTilt',betaGrid(iy),'monthlyTilt',betaGrid(im),'seasonalTilt',betaGrid(is));
end
result=struct('time',Time,'dtHours',dt_h,'months',months,'seasons',seasons, ...
    'betaGrid',betaGrid,'models',models,'modelNames',string(modelList),'latitudeTilt',abs(location.latitude));
end


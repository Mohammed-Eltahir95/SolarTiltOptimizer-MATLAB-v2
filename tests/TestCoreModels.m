classdef TestCoreModels < matlab.unittest.TestCase
 methods(Test)
  function isotropicAtZeroTiltEqualsDHI(t),c=fixture();ed=solartilt.transposeDiffuse('LiuJordan',[0;30],c);t.verifyEqual(ed(:,1),c.DHI,'AbsTol',1e-12);end
  function modelsArePhysical(t),c=fixture();names={"LiuJordan","Badescu","Klucher","Perez","HayDavies","HDKR","Koronakis","TempsCoulson"};for k=1:numel(names),ed=solartilt.transposeDiffuse(names{k},(0:10:90)',c);t.verifyTrue(all(isfinite(ed),'all'));t.verifyGreaterThanOrEqual(ed,0);end,end
  function perezUsesZenithRadians(t)
      c=fixture(); c.cosInc=repmat(cosd([0 30]),numel(c.zen),1);
      ed=solartilt.transposeDiffuse('Perez',[0;30],c);
      zrad=deg2rad(c.zen); am=1./(cosd(c.zen)+0.50572*((96.07995-c.zen).^(-1.6364)));
      epsC=((c.DHI+c.DNI)./c.DHI+1.041*zrad.^3)./(1+1.041*zrad.^3);
      edges=[1 1.065 1.230 1.500 1.950 2.800 4.500 6.200 Inf];
      C=[-.008 .588 -.062 -.060 .072 -.022;.130 .683 -.151 -.019 .066 -.029;.330 .487 -.221 .055 -.064 -.026;.568 .187 -.295 .109 -.152 -.014;.873 -.392 -.362 .226 -.462 .001;1.132 -1.237 -.412 .288 -.823 .056;1.060 -1.600 -.359 .264 -1.127 .131;.678 -.327 -.250 .156 -1.377 .251];
      delta=c.DHI.*am./c.E0; expected=zeros(size(ed)); beta=[0 30];
      for row=1:numel(c.zen)
          bin=find(epsC(row)>=edges(1:end-1)&epsC(row)<edges(2:end),1);
          f1=max(0,C(bin,1)+C(bin,2)*delta(row)+C(bin,3)*zrad(row));
          f2=C(bin,4)+C(bin,5)*delta(row)+C(bin,6)*zrad(row);
          expected(row,:)=c.DHI(row)*max(0,(1-f1)*(1+cosd(beta))/2+f1*(max(0,c.cosInc(row,1:2))/max(cosd(85),c.cosZ(row)))+f2*sind(beta));
      end
      t.verifyEqual(ed,expected,'AbsTol',1e-10);
  end
  function seasonsArePreserved(t),t.verifyEqual(solartilt.seasonId(1:12),[1 1 2 2 2 3 3 3 4 4 4 1]);end
 end
end
function c=fixture()
n=3;b=(0:10:90)';cb=cosd(b');c=struct('GHI',[600;700;500],'DHI',[100;120;90],'DNI',[700;800;600],'E0',repmat(1367,n,1),'Kt',repmat(.5,n,1),'AI',repmat(.5,n,1),'Fd',(1+cb)/2,'cosInc',repmat(cosd(b'),n,1),'cosZ',repmat(.7,n,1),'BHI',[490;560;420],'zen',repmat(45,n,1));
end


classdef TestCoreModels < matlab.unittest.TestCase
 methods(Test)
  function isotropicAtZeroTiltEqualsDHI(t),c=fixture();ed=solartilt.transposeDiffuse('LiuJordan',[0;30],c);t.verifyEqual(ed(:,1),c.DHI,'AbsTol',1e-12);end
  function modelsArePhysical(t),c=fixture();names={"LiuJordan","Badescu","Klucher","Perez","HayDavies","HDKR","Koronakis","TempsCoulson"};for k=1:numel(names),ed=solartilt.transposeDiffuse(names{k},(0:10:90)',c);t.verifyTrue(all(isfinite(ed),'all'));t.verifyGreaterThanOrEqual(ed,0);end,end
  function seasonsArePreserved(t),t.verifyEqual(solartilt.seasonId(1:12),[1 1 2 2 2 3 3 3 4 4 4 1]);end
 end
end
function c=fixture()
n=3;b=(0:10:90)';cb=cosd(b');c=struct('GHI',[600;700;500],'DHI',[100;120;90],'DNI',[700;800;600],'E0',repmat(1367,n,1),'Kt',repmat(.5,n,1),'AI',repmat(.5,n,1),'Fd',(1+cb)/2,'cosInc',repmat(cosd(b'),n,1),'cosZ',repmat(.7,n,1),'BHI',[490;560;420],'zen',repmat(45,n,1));
end


classdef TestImport < matlab.unittest.TestCase
 methods(Test)
  function canonicalCsvImports(t),root=fileparts(fileparts(mfilename('fullpath')));loc=struct('name','Test','latitude',15,'longitude',32);[w,p]=solartilt.data.importFile(fullfile(root,'tests','fixtures','canonical_weather.csv'),loc);t.verifyEqual(height(w),3);t.verifyTrue(isdatetime(w.timestamp));t.verifyEqual(p.sourceType,'file');end
  function pvgisTmyIrradianceOffsetIsApplied(t)
      rows=struct('time_UTC_',{'20060101:0000','20120201:0000'},'G_h',{0,10},'Gd_h',{0,4},'Gb_n',{0,12});
      loc=struct('name','Test','latitude',15,'longitude',32);
      w=solartilt.data.normalizePVGIS(rows,loc,0.5,true);
      t.verifyEqual(w.timestamp(1),datetime(2001,1,1,0,30,0,'TimeZone','UTC'));
      t.verifyEqual(w.timestamp(2),datetime(2001,2,1,0,30,0,'TimeZone','UTC'));
  end
 end
end


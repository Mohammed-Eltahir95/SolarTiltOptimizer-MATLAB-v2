classdef TestImport < matlab.unittest.TestCase
 methods(Test)
  function canonicalCsvImports(t),root=fileparts(fileparts(mfilename('fullpath')));loc=struct('name','Test','latitude',15,'longitude',32);[w,p]=solartilt.data.importFile(fullfile(root,'tests','fixtures','canonical_weather.csv'),loc);t.verifyEqual(height(w),3);t.verifyTrue(isdatetime(w.timestamp));t.verifyEqual(p.sourceType,'file');end
 end
end


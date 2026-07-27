function study = runStudy(config)
%RUNSTUDY Execute a configured, reproducible multi-location study.
arguments, config (1,1) struct, end
if ~isfolder(config.output.directory), mkdir(config.output.directory); end
db = solartilt.db.open(config.output.database);
cleanup = onCleanup(@() solartilt.db.closeConnection(db));
runId = solartilt.db.beginRun(db, config);
annual = table(); monthly = table(); seasonal = table(); statistics = table();
for k = 1:numel(config.locations)
    location = config.locations(k);
    [weather, provenance] = solartilt.data.loadWeather(config.dataSource, location, db);
    solartilt.data.validateWeather(weather);
    result = solartilt.optimize(weather, location, config.models, config.optimization);
    [a,m,s,stats] = solartilt.summarize(result, location);
    annual = [annual; a]; monthly = [monthly; m]; seasonal = [seasonal; s]; %#ok<AGROW>
    statistics = [statistics; stats]; %#ok<AGROW>
    solartilt.db.storeWeather(db, weather, provenance);
    solartilt.db.storeResults(db, runId, a, m, s, stats);
    if config.output.writeFigures
        solartilt.plotResults(result, location, config.output.directory);
    end
end
annual.RankWithinLocation = zeros(height(annual),1);
for name = unique(annual.Location)'
    rows = find(annual.Location==name); [~,order] = sort(annual.OptimalEnergy_kWhm2(rows),'descend');
    annual.RankWithinLocation(rows(order)) = (1:numel(rows))';
end
study = struct('runId',runId,'annual',annual,'monthly',monthly, ...
    'seasonal',seasonal,'statistics',statistics,'summary',annual);
if config.output.writeCsv
    writetable(annual, fullfile(config.output.directory,'annual_results.csv'));
    writetable(monthly, fullfile(config.output.directory,'monthly_results.csv'));
    writetable(seasonal, fullfile(config.output.directory,'seasonal_results.csv'));
    writetable(statistics, fullfile(config.output.directory,'model_statistics.csv'));
end
if config.output.writeFigures
    solartilt.plotOverview(annual, config.locations, config.output.directory);
end
solartilt.db.finishRun(db, runId, "completed");
clear cleanup
end

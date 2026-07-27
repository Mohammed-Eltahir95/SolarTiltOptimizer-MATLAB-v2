function plotOverview(annual,locations,outDir)
%PLOTOVERVIEW Cross-location model ranking, gain, and dependency-free map.
f=figure('Visible','off','Color','w');
lat=[locations.latitude]; lon=[locations.longitude]; scatter(lon,lat,90,'filled'); grid on; axis padded
xlabel('Longitude (degrees east)');ylabel('Latitude (degrees north)');title('Sudan demonstration locations');
for k=1:numel(locations),text(lon(k)+.12,lat(k),string(locations(k).name),'FontSize',9);end
exportgraphics(f,fullfile(outDir,'location_map.png'),'Resolution',180);close(f)
f=figure('Visible','off','Color','w');
locationNames=unique(annual.Location,'stable'); modelNames=unique(annual.Model,'stable');
[~,x]=ismember(annual.Location,locationNames);[~,color]=ismember(annual.Model,modelNames);
scatter(x,annual.OptimalTilt_deg,55,color,'filled');grid on;xticks(1:numel(locationNames));xticklabels(locationNames)
ylabel('Annual optimal tilt (degrees)');title('Model comparison across locations');
exportgraphics(f,fullfile(outDir,'cross_location_model_comparison.png'),'Resolution',180);close(f)
end

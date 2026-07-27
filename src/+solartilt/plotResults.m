function plotResults(r,location,outDir)
names=r.modelNames; y=zeros(numel(names),1); for k=1:numel(names),y(k)=r.models.(char(names(k))).annualTilt;end
safe=regexprep(string(location.name),'[^A-Za-z0-9_-]','_'); f=figure('Visible','off','Color','w'); bar(categorical(names),y);grid on;ylabel('Optimal tilt (degrees)');title("Annual optimal tilt — "+string(location.name));xtickangle(35);exportgraphics(f,fullfile(outDir,"annual_tilt_"+safe+".png"),'Resolution',180);close(f)
if isfield(r.models,'Perez'),f=figure('Visible','off','Color','w');plot(1:12,r.models.Perez.monthlyTilt,'-o','LineWidth',1.5);grid on;xlim([1 12]);xticks(1:12);xlabel('Month');ylabel('Optimal tilt (degrees)');title("Perez monthly profile — "+string(location.name));exportgraphics(f,fullfile(outDir,"monthly_perez_"+safe+".png"),'Resolution',180);close(f);end
end


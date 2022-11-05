function [] = beforeAfterPlot(filename)
%% Makes before and after plot of paired data and conducts paired t-test with sig. asterisk
%
% INPUTS:
% data = filepath to data file, 2 column matrix, each column is one paired group
%

%%% DEBUGGING/TEST RUN
%%% filename = 'C:\Users\Shenfeng Qiu\Documents\MATLAB\bfaPlot.mat';
%%% filename = 'C:\Users\Shenfeng Qiu\Documents\MATLAB\bfaPlot2.mat';
%%% beforeAfterPlot('C:\Users\Shenfeng Qiu\Documents\MATLAB\bfaPlot.mat');
%%% beforeAfterPlot('C:\Users\Shenfeng Qiu\Documents\MATLAB\bfaPlot2.mat');
load(filename);

figure
for i=1:size(data,1) %#ok<NODEF>
    line([1 2],[data(i,1) data(i,2)],'Color','k');
    hold on
end
xlim([0 3])
xticks([1 2])
xticklabels({'',''})

[h,p] = ttest(data(:,1),data(:,2)); %#ok<ASGLU>

sigspace = max(max(data))/30;
sigline = max(max(data))+2*sigspace;
line([0.9 0.9],[sigline sigline+sigspace],'Color','k')
line([0.9 2.1],[sigline+sigspace sigline+sigspace],'Color','k')
line([2.1 2.1],[sigline sigline+sigspace],'Color','k')

if (h)
    text(1.5,sigline+1.5*sigspace,'*','FontSize',14);
else
    text(1.45,sigline+2*sigspace,'NS','FontSize',10)
end
darkred = [0.9350 0.0580 0.0740];
mean1 = mean(data(:,1));
% errorbar(0.55,mean1,buzsem(data(:,1)),'Color',darkred,'LineWidth',2)
% offset the line start
% errorbar(0.75,mean1,0, buzsem(data(:,1)),'Color','k','LineWidth',2, 'CapSize',0)
errorbar(0.95,mean1,0, buzsem(data(:,1)),'Color','k','LineWidth',2, 'CapSize',0)
hold on
%scatter(0.75,mean1,'o','MarkerFaceColor','w','MarkerEdgeColor',darkred,'LineWidth',2)
% bar(0.75,mean1, 0.3, 'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',1.5, 'FaceAlpha',0.5)
bar(0.95,mean1, 0.3, 'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',1.5, 'FaceAlpha',0.5)

mean2 = mean(data(:,2));
orange = [0.9290 0.6940 0.1250];
% errorbar(2.25,mean2,0, buzsem(data(:,2)),'Color','r','LineWidth',2,'CapSize',0)
errorbar(2.05,mean2,0, buzsem(data(:,2)),'Color','r','LineWidth',2,'CapSize',0)
%scatter(2.25,mean2,'o','MarkerFaceColor','w','MarkerEdgeColor',orange,'LineWidth',2)
% bar(2.25,mean2, 0.3, 'FaceColor',[1 1 1],'EdgeColor',[1 0 0],'LineWidth',1.5, 'FaceAlpha',0.5)
bar(2.05,mean2, 0.3, 'FaceColor',[1 1 1],'EdgeColor',[1 0 0],'LineWidth',1.5, 'FaceAlpha',0.5)
xlim([.35 2.75])
autoArrangeFigures(0, 0,2)

end
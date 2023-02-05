function Results = s_miniAnalysis(abfFile, excelFile, time, binWidths)
%% S_MINIANALYSIS(abfFile, excelFile, time)
% abfFile = path to gap-free abf file
% excelFile = path to spreadsheet, first column event start, second column peak amplitude
% time = 2-element vector specifying which snippet of total trace to analyze (e.g. [0 40])
% binWidths = bin widths (pA, sec) for the cumulative plots of peak amplitude and IEI (e.g. [0.5 0.001])
%
% Outputs results struct with mEPSC bin, distribution values, average mEPSC value, and average mEPSC frequency

%%% abfFile = '19114005.abf';
%%% excelFile = 'mEPSC template 2.xlsx';
%%% time = [10 80];
%%% binWidths = [0.5 0.001];
%%% tic, Results = s_miniAnalysis('19114005.abf', 'mEPSC template 2.xlsx', [10 80], [0.5 0.001]), toc;

fs = 20000;
fsExcel = 1000;
rData = abf2load(abfFile);

lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
                    'PassbandFrequency',1000,'PassbandRipple',0.2, ...
                    'SampleRate',20000);
filtData = filtfilt(lpFilt,rData);
L = length(rData)/fs;
dt = 1/fs;
x = dt:dt:L;
rExcel = xlsread(excelFile);


%% Fig. 1 and 2 - Plotting 
figure(1)
plot(x,filtData,'k')
yLine = max(filtData)+3;
hold on
for i=1:length(rExcel)
    xTime = rExcel(i,1) / fsExcel;
    line([xTime xTime],[yLine yLine+2],'Color','k')
end
xlabel('Time (s)')
ylabel('Current (pA)')
title('Whole Trace')

figure(2)
xt = time(1)+dt:dt:time(2);
plot(xt,filtData((time(1)*fs)+1:time(2)*fs),'k')
hold on
for i=1:length(rExcel)
    xTime = rExcel(i,1) / fsExcel;
    line([xTime xTime],[yLine yLine+2],'Color','k')
end
xlim([time(1) time(2)])
xlabel('Time (s)')
ylabel('Current (pA)')
title('Specified Time')


%% Fig. 3 - Plotting mEPSCs over each other in specified time frame
realTimes = rExcel(:,1);
realTimes = realTimes./fsExcel;

minCut = find(realTimes < time(1));
if isempty(minCut)
    minCut = 1;
else
    minCut = max(minCut)+1;
end

maxCut = find(realTimes > time(2));
if isempty(maxCut)
    maxCut = length(realTimes);
else
    maxCut = min(maxCut)-1;
end

realTimes = realTimes(minCut:maxCut);
timeAfter = 0.05;
epscMat = zeros(length(realTimes),timeAfter*fs);
epscX = dt*1000:dt*1000:timeAfter*1000;
figure(3)
hold on
for i=1:length(realTimes)
    tempT = round(realTimes(i) * fs);
    epscMat(i,:) = rData(tempT:tempT+(timeAfter*fs)-1);
    plot(epscX,epscMat(i,:),'Color',[0.8 0.8 0.8])
end
epscAvg = mean(epscMat);
plot(epscX,epscAvg,'Color','r','LineWidth',1.5)
xlabel('Time (msec)')
ylabel('Current (pA)')
title('EPSC Plot')


%% Fig. 4 - Cumulative distribution of mEPSC amplitude and IEI
figure(4)
subplot(2,1,1)
peakAmps = abs(rExcel(minCut:maxCut,2));
paHist = histogram(peakAmps,'Normalization','cdf','BinWidth',binWidths(1),'DisplayStyle','stairs');
xlabel('mEPSC Amplitude (pA)')
ylabel('Cumulative Probability')
title('Cumulative Plots')
xlim([0 max(peakAmps)])
ylim([0 1.1])

% Calculate IEIs
minIndex = minCut-(minCut-1);
maxIndex = maxCut-(minCut-1);
for i=minIndex+1:maxIndex
    IEIs(i-1) = realTimes(i)-realTimes(i-1); %#ok<AGROW>
end
subplot(2,1,2)
ieiHist = histogram(IEIs,'Normalization','cdf','BinWidth',binWidths(2),'DisplayStyle','stairs');
xlabel('Inter-Event Interval (s)')
ylabel('Cumulative Probability')
xlim([0 max(IEIs)])
ylim([0 1.1])
avgIEI = mean(IEIs);

%% Results
Results.fig3.x = epscX;
Results.fig3.avgEPSC = epscAvg;
Results.fig4.ampEdges = paHist.BinEdges(2:end);
Results.fig4.ampCounts = paHist.BinCounts;
Results.fig4.ieiEdges = ieiHist.BinEdges(2:end);
Results.fig4.ieiCounts = ieiHist.BinCounts;
Results.fig4.avgIEI = avgIEI;
function Results = mEPSC_analysis(epsc1,epsc2, ampBounds, bin)
%% Analyzes amplitudes of two lists of mEPSCs
% SQ revision 04/2020
%  If mEPSC inter event interval also analyzed, data collected, use
%  mEPSC_analysis5, and the associated excel file instead.

% load('EPSC')
% Results = mEPSC_analysis(mEPSC1,mEPSC2,[3 60],0.5); %mEPSC2 is smaller in
% amplitude
% Results = mEPSC_analysis(mEPSC1,mEPSC2,[3 60],1); 
% Results = mEPSC_analysis(mEPSC1,mEPSC2,[0.4 5],0.2); 
% autoArrangeFigures(0, 0, 2)

%%% epsc1 = mEPSC1;
%%% epsc2 = mEPSC2;
%%% ampBounds = [4 60];
%%% bin = 1;

epsc{1} = epsc1; epsc{2} = epsc2;
epsc{1} = abs(epsc{1}); epsc{2} = abs(epsc{2});

epsc{1} = epsc{1}(epsc {1} <= ampBounds(2));
epsc{1} = epsc{1}(epsc {1} >= ampBounds(1));
epsc{2} = epsc{2}(epsc{2} <= ampBounds(2));
epsc{2} = epsc{2}(epsc{2} >= ampBounds(1));
colorList = get(gca,'ColorOrder');

figure(1)
histogram(epsc{1}, 'BinWidth', bin, 'Normalization','probability')
hold on
histogram(epsc{2}, 'BinWidth', bin, 'Normalization','probability')
hold off
xlabel('mEPSC Amplitude (pA)')
ylabel('Percentage')
title('Frequency of mEPSC Amplitudes')

figure(2)
subplot(2,1,1)
ephist1 = histogram(epsc{1}, 'BinWidth',bin, 'Normalization','probability');
x1 = ephist1.BinEdges;
x1 = x1(1:(length(x1)-1));
y1 = ephist1.BinCounts;
xlabel('mEPSC Amplitude (pA)')
ylabel('Percentage')
subplot(2,1,2)
ephist2 = histogram(epsc{2}, 'BinWidth',bin, 'Normalization','probability','FaceColor',colorList(2,:));
x2 = ephist2.BinEdges;
x2 = x2(1:(length(x2)-1));
y2 = ephist2.BinCounts;
xlabel('mEPSC Amplitude (pA)')
ylabel('Percentage')

figure(3)
stairs(x1,y1)
hold on
stairs(x2,y2)
ylabel('Count')
xlabel('mEPSC Amplitude (pA)')

figure(4)
plot(x1,y1)
hold on
plot(x2,y2)
ylabel('Count')
xlabel('mEPSC Amplitude (pA)')

figure(5)
subplot(1,2,1)
hist1 = histogram(epsc{1}, 'BinWidth',bin, 'Normalization','cdf');
cdf1.Values = hist1.Values; cdf1.x = hist1.BinEdges(1:end-1);
hist2 = histogram(epsc{2}, 'BinWidth',bin, 'Normalization','cdf');
cdf2.Values = hist2.Values; cdf2.x = hist2.BinEdges(1:end-1);
plot(cdf1.x, cdf1.Values, 'o-k', 'markerFaceColor', 'w')
hold on
plot(cdf2.x, cdf2.Values, 'o-r', 'markerFaceColor', 'w')
hold off
box off
xlabel('mEPSC Amplitude (pA)')
ylabel('Cumulative Frequency')
title('Cumulative Distribution of mEPSC Amplitudes')
subplot(1,2,2)
stairs(cdf1.x, cdf1.Values, '-k')
hold on 
stairs(cdf2.x, cdf2.Values, '-r')
box off
xlim([0 60])
ylabel('Count')
xlabel('mEPSC Amplitude (pA)')


%[h, p] = kstest2(epsc{1},epsc{2});

[h, p] = kstest2(cdf1.Values,cdf2.Values);

if(h == 1)
    text(52, 0.85, '*','FontSize',16)
else
    text(55, 0.85, 'NS','FontSize',14)
end
% Function output
Results.p = p;
Results.cdf1Bins = cdf1.x';
Results.cdf1Values = cdf1.Values';
Results.cdf2Bins = cdf2.x';
Results.cdf2Values = cdf2.Values';

figure(6)
% Y=[rand(1000,1),gamrnd(1,2,1000,1),normrnd(10,2,1000,1),gamrnd(10,0.1,1000,1)];
subplot(1,2,1)
violin(epsc{1});
hold on
hs = scatter(ones(length(epsc{1}),1), epsc{1}, 20, 'k', 'filled', 'jitter', 'on');
hs.MarkerFaceAlpha = 0.1;
ylim([0 60]);

subplot(1,2,2)
violin(epsc{2});
hold on
hs2 = scatter(ones(length(epsc{2}),1), epsc{2}, 20, 'k', 'filled', 'jitter', 'on');
hs2.MarkerFaceAlpha = 0.1;
ylim([0 60]);
autoArrangeFigures(0, 0,2)





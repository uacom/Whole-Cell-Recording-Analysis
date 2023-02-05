function Results = s_episodicStimGraph(filepath, Ch, t12)
%% S_EPISODICSTIMGRAPH will take episodic stimulation abf file and graph mean + sd patch
%
% INPUTS
% filepath - path to abf file
% Ch - channel
% t12 - [t1 t2], t range to pull data from

%%% DEBUGGING
%%% filepath = 'episodicStim1.abf';
%%% Ch = 1;
%%% t12 = [15.5 50];
%%% Results = s_episodicStimGraph('episodicStim1.abf',1,[15.5 50]);


fs=20000;
rData = abf2load(filepath);

newData = squeeze(rData(:,Ch,:));

dt = 1/fs;
realx = dt:dt:size(newData,1)/fs;
rt12 = t12./1000;

if t12(1)==0
    rt12(1) = 0.000300000000000000;
end
index(1) = find(abs(realx-rt12(1))<0.0000001);
index(2) = find(abs(realx-rt12(2))<0.0000001);

graphData = newData(index(1):index(2),:);

meanGD = mean(graphData,2);
stdGD = std(graphData'); %#ok<UDIM>

figure(1)
t = linspace(t12(1),t12(2),length(meanGD));
s_shadedErrorBar(t,meanGD,stdGD,'lineProps','r')
xlabel('Time (ms)')
ylabel('Voltage (V)')
Results.x = t;
Results.y = meanGD;
Results.std = stdGD;

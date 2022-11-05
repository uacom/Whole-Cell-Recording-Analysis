function [] = APAnalyze(actionPotentials)
%% Graphs spikes with first and second derivative
% INPUT: actionPotentials = 2-column matrix with timestamps in first column and voltage in second
 
%%% load('actionPotentials.mat') 
%%% APAnalyze(actionPotentials);

%% find the spikes
spikes = actionPotentials(:,2);
ind = actionPotentials(:,1);
iii = 1;
ii = 1;
for i=2:length(spikes)
    if ii<i
        diff = spikes(i) - spikes(i-1);
        if (diff >= 0.3 && spikes(i) < 0)
            ii = i;
            while(1)
                diffii = spikes(ii)-spikes(ii-1);
                if(diffii <= 0.2)
                    peaks(iii) = spikes(ii); %#ok<*AGROW>
                    peakInd(iii) = actionPotentials(ii,1);
                    iii = iii + 1;
                    break;
                end
                ii = ii+1;
            end
        end
    end
end

%% sort the spikes into a cell

pos = peaks > 0;
%peaks = peaks(peaks > 0);
peakInd = peakInd(pos);
apStart = peakInd-9;
apEnd = peakInd+21;
for i=1:length(peakInd)
    indStart(i) = find(ind == apStart(i));
    indEnd(i) = find(ind == apEnd(i));
    %timepoints{i} = ind(indStart(i)+1:indEnd(i));
    selSPK{i} = spikes(indStart(i)+1:indEnd(i));
end

% filter the spikes
for i=1:length(selSPK)
    selSPK{i} = smooth(selSPK{i});
end

%% graph the spikes
t = 0.05:0.05:length(selSPK{1})*0.05;
figure
for i=1:length(selSPK)
    plot(t,selSPK{i})
    hold on
end
ylabel('Membrane Potential (mV)')
xlabel('Time (ms)')
title('Raw Spikes')
hold off

%% calculate and graph derivative of spikes
for i=1:length(selSPK)
    for ii=2:length(selSPK{1})
        dselSPK{i}(ii-1) = (selSPK{i}(ii)-selSPK{i}(ii-1))/0.05;
    end
end


td1 = 0.05:0.05:length(dselSPK{1})*0.05;
figure
for i=1:length(dselSPK)
    plot(td1,dselSPK{i})
    hold on
end
ylabel('dVm/dt (mV/ms)')
xlabel('Time (ms)')
title('First Derivative')
hold off

% filter the spikes to reduce noise during derivative calculation

for i=1:length(selSPK)
    dselSPK{i} = smooth(dselSPK{i});
end

%% calculate and graph second derivative of spikes
for i=1:length(dselSPK)
    for ii=2:length(dselSPK{1})
        d2selSPK{i}(ii-1) = (dselSPK{i}(ii)-dselSPK{i}(ii-1))/0.05;
    end
end

td2 = 0.05:0.05:length(d2selSPK{1})*0.05;
figure
for i=1:length(d2selSPK)
    plot(td2,d2selSPK{i})
    hold on
end
ylabel('d^2Vm/dt^2 (mV/ms^2)')
xlabel('Time (ms)')
title('Second Derivative')
hold off
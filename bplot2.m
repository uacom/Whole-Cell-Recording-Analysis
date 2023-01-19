%%
% load sqTest.mat

bplot(boxplotmat(:,1))
hold on

bplot([boxplotmat(:,2); 124], 2)

bplot([boxplotmat(:,3); 124; 299], 3); xlim([0 4])

bplot([boxplotmat(:,4); 124; 299], 4, 'outliers'); xlim([0 5])

figure(1)

bplot(bplotcell{1}, 5, 'color','black'); xlim([0 6])


%% BLOCK #2
% load sqTest.mat

bplot(boxplotmat(:,1), 'Color', 'k')
hold on

x=ones(length(boxplotmat(:,1))).*(1+(rand(length(boxplotmat(:,1)))-0.5)/5);
f=scatter(x(:,1),boxplotmat(:,1),'k','filled');f.MarkerFaceAlpha = 0.1;hold on 

bplot([boxplotmat(:,2); 124], 2,'Color', 'r' )

x1=ones(length(boxplotmat(:,2))).*(1+(rand(length(boxplotmat(:,2)))-0.5)/5);
f1=scatter(x1(:,1)+1,boxplotmat(:,2),'r','filled');f1.MarkerFaceAlpha = 0.1;hold on 

bplot([boxplotmat(:,3); 124; 299], 3, 'Color', 'b' ); xlim([0 4])
x2=ones(length(boxplotmat(:,3))).*(1+(rand(length(boxplotmat(:,3)))-0.5)/5);
f2=scatter(x2(:,1)+2,boxplotmat(:,3),'b','filled');f2.MarkerFaceAlpha = 0.1;hold on 

bplot([boxplotmat(:,4); 124; 299], 4, 'outliers'); xlim([0 5])
x3=ones(length(boxplotmat(:,4))).*(1+(rand(length(boxplotmat(:,4)))-0.5)/5);
f3=scatter(x3(:,1)+3,boxplotmat(:,4),'b','filled');f3.MarkerFaceAlpha = 0.1;hold on 

bplot(bplotcell{1}, 5, 'color','black'); xlim([0 6])

x4=ones(length(bplotcell{1})).*(1+(rand(length(bplotcell{1}))-0.5)/5);
f4=scatter(x4(:,1)+4,bplotcell{1},'b','filled');f4.MarkerFaceAlpha = 0.1;hold on 


%% BLOCK #3
figure
bplot(randn(30,3),'outliers')
figure 
bplot(randn(30,3),'color','black');

X = round(randn(30,4)*5)/5; % random, with some duplicates
figure
T = bplot(X,'points', 'color','black');
legend(T,'location','eastoutside');

%%
load carsmall MPG              % the sample dataset variable
MPG(:,2)=MPG(:,1).*2;
MPG(:,3)=MPG(:,1).*3;
% boxplot(MPG,'Notch','on','Labels',{'mu = 5','mu = 6','mu = 6'},'Whisker',1)

% boxplot(MPG(:,1), 'Notch','on','Labels',{'mu = 5'},'Whisker',1, 'Color', 'k'); hold on; xlim([0 4])
% boxplot(MPG(:,2), 'Notch','on','Labels',{'mu = 6'},'Whisker',1,'Color', 'g' ); hold on
% boxplot(MPG(:,3), 3, 'Notch','on','Labels',{'mu = 7'},'Whisker',1, 'Color', 'b'); hold on

boxplot(MPG,'Notch','on','Labels',{'mu = 5','mu = 6','mu = 6'},'Whisker',1, 'Color', 'k')
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
% Change the boxplot color from blue to green

a = get(get(gca,'children'),'children');   % Get the handles of all the objects

%t = get(a,'tag');   % List the names of all the objects 

%box1 = a(7);   % The 7th object is the first box

set(a, 'Color', 'r');   % Set the color of the first box to green

hold on
x=ones(length(MPG)).*(1+(rand(length(MPG))-0.5)/5);
x1=ones(length(MPG)).*(1+(rand(length(MPG))-0.5)/10);
x2=ones(length(MPG)).*(1+(rand(length(MPG))-0.5)/15);
f1=scatter(x(:,1),MPG(:,1),'k','filled');f1.MarkerFaceAlpha = 0.2;hold on 
f2=scatter(x1(:,2).*2,MPG(:,2),'k','filled');f2.MarkerFaceAlpha = f1.MarkerFaceAlpha;hold on
f3=scatter(x2(:,3).*3,MPG(:,3),'k','filled');f3.MarkerFaceAlpha = f1.MarkerFaceAlpha;hold on


%% BLOCK #4


x = randn(100,25);
figure

subplot(3,1,1)
boxplot(x)

subplot(3,1,2)
boxplot(x,'PlotStyle','compact')

figure(2)
violin(x); hold on;
for ii = 1:size(x,2)
    k = ones(length(x(:,ii))).*(1+(rand(length(x(:,ii)))-0.5)/5);
    f(ii) = scatter(k(:,ii)+ii-1, x(:,ii), 10, 'k','filled');f(ii).MarkerFaceAlpha = 0.1; 
end

%% block #5
ydata = rand(50, 3)*2+2; 

[r, c] = size(ydata);

xdata = repmat(1:c, r, 1);

% for explanation see 
% http://undocumentedmatlab.com/blog/undocumented-scatter-plot-jitter
scatter(xdata(:), ydata(:), 'r.', 'jitter','on', 'jitterAmount', 0.15);

hold on;

plot([xdata(1,:)-0.25; xdata(1,:) + 0.25], repmat(mean(ydata, 1), 2, 1), 'k-')

ylim([0 max(ydata(:)+1)])

%% block 6

mpg = randn(4,7)
mpg(:,4) = NaN

figure('Color', 'w');
c = colormap(lines(3));


A = randn(60,7);        % some data
A(:,4) = NaN;           % this is the trick for boxplot
C = [c; ones(1,3); c];  % this is the trick for coloring the boxes


% regular plot
boxplot(A, 'colors', C, 'plotstyle', 'compact', ...
    'labels', {'','ASIA','','','','USA',''}); % label only two categories
hold on;
for ii = 1:3
    plot(NaN,1,'color', c(ii,:), 'LineWidth', 4);
end

title('BOXPLOT');
ylabel('MPG');
xlabel('ORIGIN');
legend({'SUV', 'SEDAN', 'SPORT'});

set(gca, 'XLim', [0 8], 'YLim', [-5 5]);

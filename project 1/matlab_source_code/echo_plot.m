%% Session 1
fileID = fopen('echo_session1.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);
sizee = size(A,1)
color = [0 0 0];
plot(A,'Color',color);
set(gca,'XTick',[0:250:3000])
set(gca,'YTick',[0:25:400])  
ylim([0 400])
xlim([0 2900])
%% Session 2
figure;
fileID = fopen('echo_session2.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);
sizee = size(A,1)
color = [0 0 0];
plot(A,'Color',color);
set(gca,'XTick',[0:250:3000])
set(gca,'YTick',[0:25:400])  
ylim([0 400])
xlim([0 2900])

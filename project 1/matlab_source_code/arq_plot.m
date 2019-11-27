%% Session 1
fileID = fopen('arq_session1.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:200:1600])
set(gca,'YTick',[0:100:1300]) 
ylim([0 1300])
xlim([0 1600])
%% Session 2
figure;
fileID = fopen('arq_session2.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:200:1600])
set(gca,'YTick',[0:100:1300]) 
ylim([0 1300])
xlim([0 1600])

%% Session 1
fileID = fopen('g3s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:1000:10000])
set(gca,'YTick',[0:40:320]) 
ylim([0 320])
xlim([20 10000])
fclose(fileID);
%% Session 2


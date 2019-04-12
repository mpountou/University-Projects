%% Session 1
fileID = fopen('g4s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:1000:11000])
set(gca,'YTick',[0:10:50]) 
ylim([0 50])
xlim([20 11000])
fclose(fileID);
%% Session 2


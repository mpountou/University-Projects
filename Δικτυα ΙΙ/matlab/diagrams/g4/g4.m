%% Session 1
fileID = fopen('g4s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:500:11000])
set(gca,'YTick',[0:10:50]) 
ylim([0 50])
xlim([20 11000])
figure
fclose(fileID);
%% Session 2
fileID = fopen('g4s2.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:500:13000])
set(gca,'YTick',[0:10:50]) 
ylim([0 50])
xlim([20 13000])
fclose(fileID);

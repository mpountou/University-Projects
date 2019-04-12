%% Session 1
fileID = fopen('g2s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:20:210])
set(gca,'YTick',[0:0.1:1.5]) 
ylim([0 1.5])
xlim([0 210])
fclose(fileID);
%% Session 2


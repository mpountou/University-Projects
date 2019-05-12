%% Session 1
fileID = fopen('g3s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:500:10500])
set(gca,'YTick',[0:40:360]) 
ylim([0 360])
xlim([20 10500])
figure
fclose(fileID);
%% Session 2
fileID = fopen('g3s2.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:500:12500])
set(gca,'YTick',[0:40:360]) 
ylim([0 360])
xlim([20 12500])
fclose(fileID);

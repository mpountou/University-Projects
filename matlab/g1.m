%% Session 1
fileID = fopen('g1s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:20:220])
set(gca,'YTick',[500:100:2300]) 
ylim([500 2300])
xlim([0 220])
figure;
fclose(fileID);
%% Session 2
fileID = fopen('g1s2.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
set(gca,'XTick',[0:20:280])
set(gca,'YTick',[200:100:1800]) 
ylim([200 1800])
xlim([0 280])
fclose(fileID);

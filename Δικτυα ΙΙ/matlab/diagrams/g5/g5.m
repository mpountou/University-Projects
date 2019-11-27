%% Session 1
fileID = fopen('g1s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
fclose(fileID);
fileID = fopen('g1s2.txt','r');
formatSpec = '%f';
B = fscanf(fileID,formatSpec);
plot(A,'Color','black');
fclose(fileID);
 
hist(A,800:300:2000)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
figure;
hist(B,450:250:1850)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
%% Session 2


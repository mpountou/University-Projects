%% Session 1
fileID = fopen('g4s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
 hist(A,0:2:40)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
figure;
fclose(fileID);
%% Session 2

fileID = fopen('g4s2.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
 hist(A,0:4:50)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 

fclose(fileID);
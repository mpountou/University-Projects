%% Session 1
fileID = fopen('g4s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
 hist(A,0:1:40)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
fclose(fileID);
%% Session 2


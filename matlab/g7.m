%% Session 1
fileID = fopen('g3s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
 hist(A,30:10:300)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
fclose(fileID);
%% Session 2


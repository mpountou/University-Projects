%% Session 1
fileID = fopen('g3s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
 hist(A,30:20:330)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
figure;
fclose(fileID);
%% Session 2
fileID = fopen('g3s2.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
 hist(A,30:20:330)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
fclose(fileID);

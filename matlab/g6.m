%% Session 1
fileID = fopen('g2s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
fclose(fileID);
hist(A,0:0.1:1)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 
%% Session 2


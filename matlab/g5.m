%% Session 1
fileID = fopen('g1s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');
fclose(fileID);
B = zeros(12,1);
for i = 1:1:size(A,1)
 if A(i,1) <=900 && A(i,1) >=800
 B(1,1) = B(1,1) + 1;
 elseif A(i,1) <=1000 && A(i,1) >=900
     B(2,1) = B(2,1) + 1;
 elseif A(i,1) <=1100 && A(i,1) >=1000
     B(3,1) = B(3,1) + 1;
 elseif A(i,1) <=1200 && A(i,1) >=1100
     B(4,1) = B(4,1) + 1;
 elseif A(i,1) <=1300 && A(i,1) >=1200
     B(5,1) = B(5,1) + 1;
 elseif A(i,1) <=1400 && A(i,1) >=1300
     B(6,1) = B(6,1) + 1;
 elseif A(i,1) <=1500 && A(i,1) >=1400
     B(7,1) = B(7,1) + 1;
 elseif A(i,1) <=1600 && A(i,1) >=1500
     B(8,1) = B(8,1) + 1;
 elseif A(i,1) <=1700 && A(i,1) >=1600
     B(9,1) = B(9,1) + 1; 
 elseif A(i,1) <=1800 && A(i,1) >=1700
     B(10,1) = B(10,1) + 1; 
 elseif A(i,1) <=1900 && A(i,1) >=1800
     B(11,1) = B(11,1) + 1;
 elseif A(i,1) <=2000 && A(i,1) >=1900
     B(12,1) = B(12,1) + 1; 
 end
end
% set(gca,'XTick',[800:100:2000])
% set(gca,'YTick',[0:5:50]) 
plot(B,'Color','black');
ylim([0 50])
xlim([800 2000])
x = [1:12];
y = [B(1,1) B(2,1) B(3,1) B(4,1) B(5,1) B(6,1) B(7,1) B(8,1) B(9,1) B(10,1) B(11,1) B(12,1)];
bar (x,y,'black','BarWidth', 0.9);
set(gca,'XTick',[0:9])

hist(A,800:300:2000)
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0]; 

%% Session 2


%% Session 1
fileID = fopen('ber_session1.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);
getSize = size(A,1)
one = 0;
two = 0;
three = 0;
four = 0;
fivee = 0 ;
six = 0;
seven = 0;
eight = 0;
nine = 0;
ten = 0;

for i = 1:1:getSize
if A(i,1) == 1
    one = one+1;
end
if A(i,1) == 2
    two = two+1;
end
if A(i,1) == 3
    three = three+1;
end
if A(i,1) == 4
    four = four+1;
end
if A(i,1) == 5
    fivee = fivee+1;
end
if A(i,1) == 6
    six = six+1;
end
if A(i,1) == 7
    seven = seven+1;
end
if A(i,1) == 8
    eight = eight+1;
end
if A(i,1) == 9
    nine = nine+1;
end
if A(i,1) == 10
    ten = ten+1;
end
end
one
two 
three
four
fivee
six
seven
eight
nine 
ten
x = [1:7];
xlim([1 7]);
y = [one two three four fivee six seven];
bar (x,y,'black','BarWidth', 0.9);
set(gca,'XTick',[0:9])

figure;
%% Session 2
fileID = fopen('ber_session2.txt','r');
formatSpec = '%d';
A = fscanf(fileID,formatSpec);
getSize = size(A,1)
one = 0;
two = 0;
three = 0;
four = 0;
fivee = 0 ;
six = 0;
seven = 0;
eight = 0;
nine = 0;
ten = 0;

for i = 1:1:getSize
if A(i,1) == 1
    one = one+1;
end
if A(i,1) == 2
    two = two+1;
end
if A(i,1) == 3
    three = three+1;
end
if A(i,1) == 4
    four = four+1;
end
if A(i,1) == 5
    fivee = fivee+1;
end
if A(i,1) == 6
    six = six+1;
end
if A(i,1) == 7
    seven = seven+1;
end
if A(i,1) == 8
    eight = eight+1;
end
if A(i,1) == 9
    nine = nine+1;
end
if A(i,1) == 10
    ten = ten+1;
end
end
one
two 
three
four
fivee
six
seven
eight
nine 
ten
x = [1:7];
xlim([1 7]);
y = [one two three four fivee six seven];
bar (x,y,'black','BarWidth', 0.9);
set(gca,'XTick',[0:9])

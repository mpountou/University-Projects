% AQDCPM SAMPLE CODE SONG 9271
% g13s1.txt == AQDCPM_SAMPLE_CODE_XXXX_SONG.txt
fileID = fopen('g13s1.txt');
mydata = textscan(fileID,'%f%f','HeaderLines',1);
fclose(fileID);
columns = cell2mat(mydata);
column_1 = columns(:,1);
column_2 = columns(:,2);
j = 1 ;
for i = 1: size(column_1,1)
    a(j) = column_1(i) ;
    j = j + 1 ;
    a(j) = column_2(i) ;
    j = j+1;
end
histogram(a,'FaceColor','black','FaceAlpha',0.95);

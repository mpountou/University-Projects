% AQDPCM SONG MEANS
% g17s1.txt == AQDCPM_MEANS_CODE_XXXX_SONG.txt
fileID = fopen('g17s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');


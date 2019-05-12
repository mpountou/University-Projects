% AQDPCM SONG BETAS
% g16s1.txt == AQDCPM_BETAS_CODE_XXXX_SONG.txt
fileID = fopen('g16s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');



% AQDPCM SONG BETAS
% g18s1.txt == AQDCPM_BETAS_CODE_XXXX_SONG.txt
fileID = fopen('g18s1.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
plot(A,'Color','black');



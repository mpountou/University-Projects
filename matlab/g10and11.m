% DCPM SAMPLE CODE SONG 9271
j = 1 ;
for i = 1: size(VarName1,1)
    a(j) = VarName17(i) ;
    j = j + 1 ;
    a(j) = VarName18(i) ;
    j = j+1;
end
%step 1 for G10
plot(a,'Color','black');
xlim([0 250000]);
figure;
%step 2 for G11
histogram(a,'FaceColor','black','FaceAlpha',1);
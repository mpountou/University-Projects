% DCPM SAMPLE CODE FREQ 9271
j = 1 ;
for i = 1: size(VarName5,1)
    a(j) = VarName19(i) ;
    j = j + 1 ;
    a(j) = VarName20(i) ;
    j = j+1;
end
histogram(a,'FaceColor','black','FaceAlpha',0.95);

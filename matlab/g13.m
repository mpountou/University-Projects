% ?QDCPM SAMPLE CODE SONG 9271
j = 1 ;
for i = 1: size(VarName21,1)
    a(j) = VarName21(i) ;
    j = j + 1 ;
    a(j) = VarName23(i) ;
    j = j+1;
end
histogram(a,'FaceColor','black','FaceAlpha',0.95);

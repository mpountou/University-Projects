% AQDCPM subs CODE song 9271
j = 1 ;
for i = 1: size(VarName24,1)
    a(j) = VarName24(i) ;
    j = j + 1 ;
    a(j) = VarName25(i) ;
    j = j+1;
end
histogram(a,'FaceColor','black','FaceAlpha',0.95);

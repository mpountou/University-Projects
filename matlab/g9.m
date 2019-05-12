% DCPM SAMPLE CODE FREQ 9271
j = 1 ;
for i = 1: size(VarName1,1)
    a(j) = VarName15(i) ;
    j = j + 1 ;
    a(j) = VarName16(i) ;
    j = j+1;
end
plot(a,'Color','black');
xlim([120000 123000]);
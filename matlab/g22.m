% vehicle engine rpm
v1 = hex2dec(v(:,3));
v2 = hex2dec(v(:,4));
XX = v1;
YY = v2;
result = ((256*XX) + YY)/4;
plot(result,'Color','black');
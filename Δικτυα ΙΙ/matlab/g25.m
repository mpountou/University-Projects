% vehicle throttle pos
v1 = hex2dec(v(:,3));
XX = v1*100/255;
result = XX;
plot(result,'Color','black');
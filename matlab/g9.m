
fs= 8000;
tonef= fopen('t.txt','r');
tone= fread(tonef,'int16'); 
tonet= linspace(0,length(tone)/fs, length(tone));
% message length = 256bytes
tone= 2*(tone-mean(tone))/max(abs(tone));
figure(9);
plot(tonet(end/2:end/2+fs), tone(end/2:end/2+fs));

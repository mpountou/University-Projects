
fs= 8000;
tonef= fopen('t.txt','r');
tone= fread(tonef,'int16'); 
tonet= linspace(0,length(tone)/fs, length(tone));
% message length = 256bytes
tone= 2*(tone-mean(tone))/max(abs(tone));
figure(9);
subplot(211);
plot(tonet(end/2:end/2+fs), tone(end/2:end/2+fs));
title('G9: Tone waveform (1sec) (V2065)'); xlabel('t (s)'); axis tight;
subplot(212);
%plot(linspace(-4000,4000,length(tone)),abs(fftshift(fft(tone))));
spectrogram(tone,2000,1900,512,fs,'yaxis');
title('G9: Tone spectrogram');

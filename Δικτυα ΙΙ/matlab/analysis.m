%% Net analysis
clear; close all;
dir= '10-06 02:43:14'; dir= '27-05 17:45:03'; dir= '10-06 02:18:59';
mkdir(['results/',dir]);
%{
%% Echo: G1-8
load(['../permLogs/',dir,'/echoE7956.log']);
echodel= echoE7956(:,2); echot= echoE7956(:,1)/1000;
for opI= 1:2:3
  % Display delay
  figure(opI);
  plot(echot,echodel); title(sprintf('G%d: Echo delays in time (E7956)',opI)); grid on;
  xlabel('t (s)'); ylabel('delay (ms)');
  saveas(gcf, ['results/',dir,sprintf('/G%d.pdf', opI)]);
  figure(opI+4);
  histogram(echodel); title(sprintf('G%d: Echo delay histogram (E7956)',opI+4)); xlabel('delay (ms)');
  saveas(gcf, ['results/',dir,sprintf('/G%d.pdf', opI+4)]);
  
  fprintf('Echo delay: mean=%gms var=%gms^2\n', mean(echodel), var(echodel));

  % Sliding window throughput: transform the arrival timestamps vector echot into a steady
  % clock with the packet arrival times indicated.
  N= 100*length(echot);
  packetArrivals(:,1)= linspace(echot(1),echot(end),N);
  packetArrivals(:,2)= zeros(N,1);
  % Associate each packet arrival timestamp with an instance in the steady clock
  pt= 0;
  for i= 1:length(echot)
    pt= pt+ find(packetArrivals(pt+1:end,1) > echot(i), 1);
    packetArrivals(pt, 2)= 1;
  end
  % Calculate throughput
  baseL= N/(echot(end)-echot(1));
  l8= round(8*baseL); l16= round(16*baseL); l32= round(32*baseL); l64= round(64*baseL);
  tw8= ones(l8,1)/(l8); tw16= ones(l16,1)/(l16);
  tw32= ones(l32,1)/(l32); tw64= ones(l64,1)/(l64);
  throughput(:,1)= conv(packetArrivals(:,2),tw8,'same');
  throughput(:,2)= conv(packetArrivals(:,2),tw16,'same');
  throughput(:,3)= conv(packetArrivals(:,2),tw32,'same');
  throughput(:,4)= conv(packetArrivals(:,2),tw64,'same');
  % Display throughput
  figure(opI+1);
  plot(packetArrivals(:,1),throughput); grid on;
  title(sprintf('G%d: Throughput in time, variable window length (E7956)',opI+1));
  xlabel('t (s)'); ylabel('throughput (pps)'); legend('w=8sec','w=16sec','w=32sec','w=64sec');
  saveas(gcf, ['results/',dir,sprintf('/G%d.pdf', opI+1)]);
  figure(opI+5);
  histogram(throughput(:,2));
  title(sprintf('G%d: Throughput histogram, window=16sec (E7956)', opI+5)); xlabel('throughput (pps)');
  saveas(gcf, ['results/',dir,sprintf('/G%d.pdf', opI+5)]);
  
  % Load nodelay data and redo
  load(['../permLogs/',dir,'/echoE7956_nodelay.log']);
  echodel= echoE7956_nodelay(:,2); echot= echoE7956_nodelay(:,1)/1000;
  clear('packetArrivals','throughput');
end
%}
clear('echo*','tw*','l*');
%% Audio: G9-10

fs= 8000;
tonef= fopen(['../permLogs/',dir,'/toneV2065.log_diff_samp']);
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
saveas(gcf, ['results/',dir,'/G9.pdf']);

musicf= fopen(['../permLogs/',dir,'/musicV2065.log_diff_samp']);
music= fread(musicf,'int16'); musict= linspace(0,length(music)/fs, length(music));
music= 2*(music-mean(music))/max(abs(music));
figure(10);
subplot(211);
plot(musict(end/2:end/2+fs), music(end/2:end/2+fs));
title('G10: Music waveform (1sec) (V2065)'); xlabel('t (s)'); axis tight;
subplot(212);
%plot(abs(fftshift(fft(music))));
spectrogram(music,blackman(800),490,512,fs,'yaxis');
title('G10: Music spectrogram');
saveas(gcf, ['results/',dir,'/G10.pdf']);
%}
%% G11-G14
tonedifff= fopen(['../permLogs/',dir,'/toneV2065.log_diff_split']);
tonediff= fread(tonedifff,'int8');
figure(11);
subplot(211); histogram(tonediff); title('G11: Tone diff histogram (V2065)');
subplot(212); histogram(tone); title('G12: Tone sample histogram');
saveas(gcf, ['results/',dir,'/G11_12.pdf']);

musicdifff= fopen(['../permLogs/',dir,'/musicV2065.log_diff_split']);
musicdiff= fread(musicdifff, 'int8');
figure(13);
subplot(211); histogram(musicdiff); title('G13: Music diff histogram (V2065)');
subplot(212); histogram(music); title('G14: Music sample histogram');
saveas(gcf, ['results/',dir,'/G13_14.pdf']);

%% G15-16
musicmuf= fopen(['../permLogs/', dir, '/musicV2065.log_diff_mu']);
mu= fread(musicmuf, 'int16');
paramt= linspace(musict(1), musict(end), length(mu));
figure(15);
plot(paramt,mu); title('G15: Quantizer mean (V2065)'); xlabel('t (s)');
saveas(gcf, ['results/',dir,'/G15.pdf']);

musicbetaf= fopen(['../permLogs/', dir, '/musicV2065.log_diff_beta']);
beta= fread(musicbetaf, 'int16');
figure(16);
plot(paramt,beta); title('G16: Quantizer step (V2065)'); xlabel('t (s)');
saveas(gcf, ['results/',dir,'/G16.pdf']);
%{
clear('tone*','music*','mu','beta','fs'); close all;
%% Copter: G19-20
copterf= fopen(['../permLogs/',dir,'/copter_fl1Q5411.log']);
fl= str2double(fgetl(copterf));
copter1= textscan(copterf, '%d %d %d %d %d');
coptm= copter1{1}; coptalt= copter1{3}; copttemp= copter1{4}; coptpres= copter1{5};
figure(19);
subplot(211);
plot([coptm, coptalt]); title(sprintf('G19: Copter control (flight level: %d) (Q5411)', fl));
xlabel('t'); legend('motor', 'altitude'); grid minor;
subplot(212);
semilogy([coptalt, copttemp, coptpres]);
title(sprintf('G19: Copter measurements (flight level: %d)', fl)); xlabel('t');
legend('altitude', 'temperature', 'pressure'); grid minor;
saveas(gcf, ['results/',dir,'/G19.pdf']);

copterf= fopen(['../permLogs/',dir,'/copter_fl2Q5411.log']);
fl= str2double(fgetl(copterf));
copter2= textscan(copterf, '%d %d %d %d %d');
coptm= copter2{1}; coptalt= copter2{3}; copttemp= copter2{4}; coptpres= copter2{5};
figure(20);
subplot(211);
plot([coptm, coptalt]); title(sprintf('G20: Copter control (flight level: %d) (Q5411)', fl));
xlabel('t'); legend('motor', 'altitude'); grid minor;
subplot(212);
semilogy([coptalt, copttemp, coptpres]);
title(sprintf('G20: Copter measurements (flight level: %d)', fl)); xlabel('t');
legend('altitude', 'temperature', 'pressure'); grid minor;
saveas(gcf, ['results/',dir,'/G19.pdf']);
%}

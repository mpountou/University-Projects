format long

%% define AEM

a1 = 8;
a2 = 8;
a3 = 7;
a4 = 2;

%% calculate m

if (a4>=4) && (a4<=6)
    m = 0
elseif (a4>=0) && (a4<=3)
    m = 1
else
    m = 2
end

%% frequencies

fp = (4+m) * 1000

fs = fp / 2.6

amin = 24 + a3 * (6/9)

amax = 0.5 +  a4 / 36
 
%% strategy 2

omegas = 2*pi*fs % ws

omegap = 2*pi*fp % wp

%% class

n = (log ( (10^(amin/10) -1) / (10^(amax/10) -1) ) ) / (2 * log(omegap / omegas))

n = ceil(n)

Omegap = 1 % Wp

Omegas = omegap / omegas % Ws

Omega0 = 1 / (10^(amax/10) -1)^(1/(2*n))

omega0 = omegap / Omega0

Q1 = 0.5

Q2 = 0.618

Q3 = 1.6189

%% MONADA 1

c11 = 1

r11 = 1

kf1 = omega0

km1 = 1 / (kf1*10^(-7))

A = 1 / (kf1*km1)

C11 = A

R11 = km1

%% MONADA 2

c21 = 1

c22 = 1

r21 = 1 / (2*Q2)

r22 = 2*Q2

k = 1

kf2 = omega0

km2 = 1 / (kf2*10^(-7))

A = 1 / (kf2*km2)

C21 = A

C22 = A

R21 = r21 *km2

R22 = r22 * km2

%% MONADA 3

c31 = 1

c32 = 1

r31 = 1 / (2*Q3)

r32 = 2*Q3

k = 1

kf3 = omega0

km3 = 1 / (kf3*10^(-7))

A = 1 / (kf3*km3)

C31 = A

C32 = A

R31 = r31 *km3

R32 = r32 * km3

%% transfer function

t1 = tf([1 0],[1 omega0]);

t2 = tf([1 0 0],[1 omega0/Q2 omega0^2])
 
t3 = tf([1 0 0],[1 omega0/Q3 omega0^2])

t= t1*t2*t3

%% plots

plot_transfer_function( t1, [fs fp]);

plot_transfer_function( t2, [fs fp]);

plot_transfer_function( t3, [fs fp]);

plot_transfer_function( t, [fs fp]);

%% plots

figure;
bodemag(t1)
hold on 
bodemag(t2)
bodemag(t3)
bodemag(t)
legend('T1(s)','T2(s)','T3(s)','T(s)')
grid on

aposvesi = inv(t);
plot_transfer_function(aposvesi, [fs fp]);

%1
omegain1 = 0.4*omegas
fin1 = omegain1 / (2*pi)
%0.5
omegain2 = 0.9*omegas
fin2 = omegain2 / (2*pi)
% 1
omegain3 = 1.4*omegap
fin3 = omegain3 / (2*pi)
% 0.7
omegain4 = 2.4 * omegap 
fin4 = omegain4 / (2*pi)
% 0.5
omegain5 = 4.5*omegap
fin5 = omegain5 / (2*pi)

%% FOURIER ANALYSIS

sys = t;
T = (1.5);
Fs = 1000000;
dt = 1/Fs;
t = 0:dt:T-dt;
x = cos(omegain1*t) + 0.5 *cos(omegain2*t) + cos(omegain3*t) + 0.7*cos(omegain4*t) + 0.5*cos(omegain5*t);
figure;
plot(t,x);
axis([0 inf -0.5 1.5]);
title('Input signal');
y=lsim(sys,x,t);
figure;
plot(t,y);
title('Output signal');


%% FOURIER INPUT


Xf=fft(x);
L=length(x);
P2 = abs(Xf/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure;
plot(f,P1);
axis([0.01 25000 0 inf]);
title('FFT of Input signal');

%% FOURIER OUTPUT

Yf=fft(y);
L=length(y);
P2 = abs(Yf/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure;
plot(f,P1);
axis([0.01 25000 0 inf]);
title('FFT of Output signal');


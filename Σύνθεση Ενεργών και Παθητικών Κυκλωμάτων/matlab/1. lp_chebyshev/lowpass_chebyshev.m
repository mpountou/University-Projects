format long

%% define AEM

a1 = 8;
a2 = 8;
a3 = 7;
a4 = 2;
 
%% calculate m

if (a3>=0) && (a3<=2)
    m = 1
elseif (a3>=3) && (a3<=6)
    m = 2
else
    m = 3
end

%% calculate frequencies

fp = (3+m) * 1000

fs = 1.72*fp

%% attenuation 

amin = 24 + (max(1,a3) -5 ) * (3/4)

amax = 0.65 + (max(1,a4)-5)/10

%% strategy 2

n = acosh( sqrt( (((10^(amin/10)) -1) / ( (10^(amax/10)) -1 ))) ) / acosh(1.72)

n=ceil(n) % choose next integer

%% frequencies

omegas = 2*pi*fs % ws

omegap = 2*pi*fp % wp

Omegap = 1 % Wp

Omegas = 1.72 % Ws

Omegahp = cosh ( (1/n) * acosh(1/ ( sqrt(10^(amax/10) -1) ) ) )% Whp

fhp = Omegahp * fp 

omegahp = 2*pi*fhp %whp

%% others

e = sqrt ( ((10^(amax/10)) -1) )

a = (1/n) * asinh(1/e)

angle1 = 0; 

angle2 = pi / 5; %36 moires

angle3 = pi / 2.5; %72 moires

%% calculate poles

real1 = sinh(a) * cos(angle1)

imagine1 = cosh(a) *sin(angle1)

real2 = sinh(a) * cos(angle2)

imagine2 = cosh(a) *sin(angle2)

real3 = sinh(a) * cos(angle3)

imagine3 = cosh(a) *sin(angle3)

OMEGA01 =  sqrt(real1^2+imagine1^2)

OMEGA023 =  sqrt(real2^2+imagine2^2)

OMEGA045 =  sqrt(real3^2+imagine3^2)

omega1 = 2*pi*6000 * OMEGA01

omega23 = 2*pi*6000*OMEGA023

omega45 = 2*pi*6000*OMEGA045

Q1 = OMEGA01 / (2*real1)

Q23 = OMEGA023 / (2*real2)

Q45 = OMEGA045 / (2*real3)

%% MONADA 1

kf1 = omegap   

km1 = 10000

R11 = 1

c11 = 1 / real1

A = 1 / (km1*kf1)

R11 = km1

C11 = A * c11

%% MONADA 2

c21 = 2*Q23

c22 = 1 / (2*Q23)

r21 = 1

r22 = 1

kf2 = OMEGA023 * omegap

km2 = (c21) / ((10^(-6)) *kf2)

A2 = 1 / (km2*kf2)

C21 = c21 * A2

C22 = c22 * A2

R21 = km2

R22 = km2

%% MONADA 3

c31 = 2*Q45

c32 = 1 / (2*Q45)

r31 = 1

r32 = 1

kf3 = OMEGA045 * omegap

km3 = (c31) / ((10^(-6)) *kf3)

A3 = 1 / (km3*kf3)

C31 = c31 * A3

C32 = c32 * A3

R31 = km3

R32 = km3

%% transfer functions

t1 = tf([omega1],[1 omega1]);

t2 = tf([omega23^2],[1 (omega23/Q23) omega23^2]);

t3 = tf([omega45^2],[1 (omega45/Q45) omega45^2]);

t = t1*t2*t3;

ap = inv(t);

%% plots

plot_transfer_function( t1, [fs fp]); %t1

plot_transfer_function( t2, [fs fp]); %t2

plot_transfer_function( t3, [fs fp]); %t3

plot_transfer_function( t, [fs fp]); % t

plot_transfer_function( ap, [fs fp]);

figure;
bodemag(t1)
hold on 
bodemag(t2)
bodemag(t3)
bodemag(t)
legend('T1(s)','T2(s)','T3(s)','T(s)')
grid on

%% FOURIER ANALYSIS

sys = t;

T_total = (1/100);

F_sample = 1000000;

dt = 1/F_sample;

t = 0:dt:T_total-dt;

x = 0.5*square(2*pi*2000*t,40)+0.5; %input

figure;

plot(t,x);

axis([0 inf -0.5 1.5]);

title('Input signal');

y=lsim(sys,x,t); %output

figure;

plot(t,y);

title('Output signal');

%% FOURIER INPUT

Xf=fft(x);

L=length(x);

P2 = abs(Xf/L);

P1 = P2(1:L/2+1);

P1(2:end-1) = 2*P1(2:end-1);

f = F_sample*(0:(L/2))/L;

figure;

plot(f,P1);

axis([0.01 11000 0 inf]);

title('FFT of Input signal');

%% FOURIER OUTPUT

Yf=fft(y);

L=length(y);

P2 = abs(Yf/L);

P1 = P2(1:L/2+1);

P1(2:end-1) = 2*P1(2:end-1);

f = F_sample*(0:(L/2))/L;

figure;

plot(f,P1);

axis([0.01 20000 0 inf]);

title('FFT of Output signal');
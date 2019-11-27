format long

%% define AEM

a1 = 8;
a2 = 8;
a3 = 7;
a4 = 2;

%% frequencies

f0 = 2400

f1 = 1725 + 25*a4

f2 = (f0^2) / f1

D = (1 / 2.2) * ((f0^2 - f1^2) / f1) 

f3 = (-D + sqrt(D^2 + 4*f0^2)) / 2

f4 = (f0^2) / f3

%% attenuation

amin = 28 + a3 * (5/9)

amax = 0.5 + (a4 / 18)

%% others

omega1 = 2 * pi * f1 

omega2 = 2 * pi * f2 

omega3 = 2 * pi * f3 

omega4 = 2 * pi * f4 

omega0 = sqrt(omega1 * omega2) 

bw = omega2 - omega1 

OMEGAP = 1 

OMEGAS =  ( omega2 - omega1 ) / (omega4 - omega3) 

%% class

n = acosh( sqrt( (((10^(amin/10)) -1) / ( (10^(amax/10)) -1 ))) ) / acosh(OMEGAS)

n= ceil(n)

%% others 

e = 1 /( sqrt ( ((10^(amin/10)) -1) ) ) 

a = (1/n) * asinh(1/e) 

omega3db = 1 / ( (10^(amax/10) - 1 ) ^(1/(2*n)))

angle0 = pi / 8; % 22.5 

angle1 = 3 * pi / 8;  % 67.5

%% total poles: 4

real1 = sinh(a) * cos(angle0)

imagine1 = cosh(a)* sin(angle0)

real2 = sinh(a) * cos(angle1)

imagine2 = cosh(a)* sin(angle1)

OMEGA012 = sqrt ( real1^2 + imagine1^2 ) 

OMEGA034 = sqrt ( real2^2 + imagine2^2 ) 

Q12 = OMEGA012 / (2 * real1) 

Q34 = OMEGA034 / (2 * real2)

tOMEGA012 = 1 / OMEGA012 

tOMEGA034 = 1 / OMEGA034

tkOMEGA012 = OMEGAS * tOMEGA012

tkOMEGA034 = OMEGAS * tOMEGA034

OMEGAZ1 = sec (pi / (2*n) )

OMEGAZ2 = sec (3*pi / (2*n)) 

tOMEGAZ1 = OMEGAS * OMEGAZ1

tOMEGAZ2 = OMEGAS * OMEGAZ2

hOMEGA012 = 1 / tkOMEGA012

hOMEGA034 = 1 / tkOMEGA034

hOMEGAZ1 = 1 / tOMEGAZ1

hOMEGAZ2 = 1 / tOMEGAZ2

hS12 =  (-hOMEGA012) / (2*Q12)

hS34 = (-hOMEGA034) / (2*Q34)

hOMEGA12 = sqrt( (hOMEGA012)^2 - (hS12)^2 )

hOMEGA34 = sqrt( (hOMEGA034)^2 - (hS34)^2 )

qc = omega0 / bw 

%% pole transform

real12 = -hS12

imagine12 = -hOMEGA12

C12 = real12^2 + imagine12^2

D12 = (2*real12) / qc

E12 = 4 + C12 / (qc*qc)

G12 = sqrt(E12^2 - 4*D12^2)

Q1_2 = (1/D12) * sqrt((1/2) *(E12+G12))

k12 = (real12* Q1_2) / qc

W12 = k12 + sqrt(k12^2-1)

omega01 = W12 * omega0

omega02 =(1/ W12) * omega0

%% pole transform

real34 = -hS34

imagine34 = -hOMEGA34

C34 = real34^2 + imagine34^2

D34 = (2*real34) / qc

E34 = 4 + C34 / (qc*qc)

G34 = sqrt(E34^2 - 4*D34^2)

Q3_4 = (1/D34) * sqrt((1/2) *(E34+G34))

k34 = (real34* Q3_4) / qc

W34 = k34 + sqrt(k34^2-1)

omega03 = W34 * omega0

omega04 =(1/ W34) * omega0

%% zero transform

K = 2+ hOMEGAZ1^2 /  qc^2

x = (K + sqrt(K^2-4)) / 2

omegaz1 = omega0 * sqrt(x)

omegaz2 = omega0 * (1 / sqrt(x))

%% next zero transform

K = 2+ hOMEGAZ2^2 /  qc^2

x = (K + sqrt(K^2-4)) / 2

omegaz3 = omega0 * sqrt(x)

omegaz4 = omega0 * (1 / sqrt(x))

%% transfer function 

t1 = tf([1 0 omegaz1^2],[1 (omega01/Q1_2) omega01^2]);

t2 = tf([1 0 omegaz2^2],[1 (omega02/Q1_2) omega02^2]);

t3 = tf([1 0 omegaz3^2],[1 (omega03/Q3_4) omega03^2]);

t4 = tf([1 0 omegaz4^2],[1 (omega04/Q3_4) omega04^2]);

t=1.778279* t1*t2*t3*t4;

%% plots

plot_transfer_function( t1, [f0 f1 f2 f3 f4]);

plot_transfer_function( t2, [f0 f1 f2 f3 f4]);

plot_transfer_function( t3, [f0 f1 f2 f3 f4]);

plot_transfer_function( t4, [f0 f1 f2 f3 f4]);

plot_transfer_function( t, [f0 f1 f2 f3 f4]);

%% case1: omegaz1 > omega01
OMEGA0 = 1

OMEGAZ = omegaz1 / omega01

k = 0.95

r11 = 2 / (k * OMEGAZ^2 -1)

r12 = 1 / (1-k)

r13 = (1/2) * (k/(Q1_2^2) + k * OMEGAZ^2-1)

r14 = 1 / k

r15 = 1

r16 = 1

c11 = k / (2*Q1_2)

c12 = 2 * Q1_2

gain1 = 1 / ( (1/2) * ( k/(Q1_2^2) + k * OMEGAZ^2 + 1) )

kf1 = omega01 

km1 = (10^8 / kf1 ) * c11

R11 = r11*km1

R12 = r12*km1

R13 = r13*km1

R14 = r14*km1

R15 = r15*km1

R16 = r16*km1

C11 = (1/ (km1*kf1)) * c11

C12 = (1/ (km1*kf1)) * c12

%% case2: boctor(omegaz2,omega02,Q1_2)

R21 = 1.785072152781381e+03

R22 = 3.183972657905790e+04

R23 = 1.064315645196665e+02

R24 = 2000

R25 = 2000

R26 = 1.059215222637715e+02

C21 = 10^-8

C22 = 10^-8

gain2 = 2

%% case3
%% boctor(omegaz3,omega03,Q3_4)
%% A Boctor HPN cannot be defined. You should use a High Pass Notch (Fig. 7.21).

k1 =  (omega03 / omegaz3)^2 -1
k2 =  ( (2+k1) * Q3_4^2 ) / ( (2+k1)* Q3_4^2 +1)
gain3 = k2 * (omega03 / omegaz3)^2
r32 = (Q3_4^(2))  * (k1+2)^2
r34 = (Q3_4^2) * (k1+2)
c31 = 1 / (Q3_4 *(2+k1))
c32 = c31
c33 = c32
kf3 = omega03
km3 = (10^8 / kf3 ) * c31
R31 = km3
R32 = r32 * km3
R33 = km3
R34 = km3 * r34
C31 = (1/(km3*kf3)) * c31
C33= k1 * C31

%% case4: omegaz4 > omega04

OMEGA0 = 1

OMEGAZ = omegaz4 / omega04

k = 0.95

r41 = 2 / (k * OMEGAZ^2 -1)

r42 = 1 / (1-k)

r43 = (1/2) * (k/(Q3_4^2) + k * OMEGAZ^2-1)

r44 = 1 / k

r45 = 1

r46 = 1

c41 = k / (2*Q3_4)

c42 = 2 * Q3_4

gain4 = 1 / ( (1/2) * ( k/(Q3_4^2) + k * OMEGAZ^2 + 1) )

kf4 = omega04 

km4 = (10^8 / kf4 ) * c41

R41 = r41*km4

R42 = r42*km4

R43 = r43*km4

R44 = r44*km4

R45 = r45*km4

R46 = r46*km4

C41 = (1/ (km4*kf4)) * c41

C42 = (1/ (km4*kf4)) * c42

%% gain

totalgain = gain1*gain2*gain3*gain4

r1 = 1 / totalgain

r2 = 1

r1 = 10000 * r1

r2 = 10000

%% plots

figure;
bodemag(t1)
hold on 
bodemag(t2)
bodemag(t3)
bodemag(t4)
bodemag(t)
legend('T1(s)','T2(s)','T3(s)','T4(s)','T(s)')
grid on

aposvesi = inv(t);

plot_transfer_function(aposvesi, [f0 f1 f2 f3 f4]);

t_0dB= t1*t2*t3*t4;

plot_transfer_function(t_0dB, [f0 f1 f2 f3 f4]);

%% input signal

%0.5
omegain1 = omega0 - (omega0-omega3)/2
fin1 = omegain1 / (2*pi)
%0.8
omegain2 = omega0 + (omega0+omega3)/3
fin2 = omegain2 / (2*pi)
%0.8
omegain3 = 0.4*omega1
fin3 = omegain3 / (2*pi)
%0.6
omegain4 = 2.5*omega2
fin4 = omegain4 / (2*pi)
%1.2
omegain5 = 3*omega2
fin5 = omegain5 / (2*pi)

%% FOURIER ANALYSIS

sys = t;
T = (2.5);
Fs = 1000000;
dt = 1/Fs;
t = 0:dt:T-dt;
x = 0.5*cos(omegain1*t) + 0.8 *cos(omegain2*t) + 0.8*cos(omegain3*t) + 0.6*cos(omegain4*t) + 1.2*cos(omegain5*t);
figure;
plot(t,x);
axis([0 inf -2.5 2.5]);
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
axis([0.01 10000 0 inf]);
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
axis([0.01 10000 0 inf]);
title('FFT of Output signal');

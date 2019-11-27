format long g

%% define AEM

a1 = 8;
a2 = 8;
a3 = 7;
a4 = 2;

%% frequencies

f0 = 900 

f1 = 650 + 25 * a3

f2 = ( (f0)^2 ) / f1

D = 2.2 * ( (f0)^2 - (f1)^2 ) / f1

f3 = (-D + sqrt(D^2 + 4*f0^2) ) / 2

f4 = (f0^2) / f3

%% attenuation 

amin = 28.5 + a4 * 5 / 9

amax = 0.5 + a3 / 36

%% frequencies

omega1 = 2 * pi * f1

omega2 = 2 * pi * f2

omega3 = 2 * pi * f3

omega4 = 2 * pi * f4

OMEGAP = 1

OMEGAS = (omega4 - omega3) / (omega2 - omega1)

omega0 = sqrt ( omega1 * omega2 )

%% bandwidth

bw = omega2 - omega1

%% class

n = acosh( sqrt( (((10^(amin/10)) -1) / ( (10^(amax/10)) -1 ))) ) / acosh(2.2)

n = ceil(n) 

%% others 

e = sqrt ( ((10^(amax/10)) -1) )

Omegahp = cosh ( (1/n) * acosh(1/ ( sqrt(10^(amax/10) -1) ) ) )% Whp

a = (1/n) * asinh(1/e)

angle0 = pi / 8;

angle1 = 3 * pi / 8; 

koa = cosh(a)

sia = sinh(a)

real1 = sia * cos(angle0)

imagine1 = koa* sin(angle0)

real2 = sia * cos(angle1)

imagine2 = koa* sin(angle1)

qc = omega0 / bw

%% first pair of poles

Sigma1_2 = real1

Omega1_2 = imagine1

C1_2 = (Sigma1_2)^2 + (Omega1_2)^2

D1_2 = (2 * Sigma1_2) / qc

E1_2 = 4 + (C1_2) / (qc)^2

G1_2 = sqrt ( (E1_2)^2 -4*(D1_2)^2)

Q1_2 = (1/D1_2) * sqrt( (1/2) * (E1_2 + G1_2) )

k1_2 = (Sigma1_2 * Q1_2) / qc

W1_2 = k1_2 + sqrt((k1_2)^2 -1)

omega01_12 = (1 / W1_2) * omega0

omega02_12 = W1_2 * omega0

%% second pair of poles

Sigma3_4 = real2

Omega3_4 = imagine2

C3_4 = (Sigma3_4)^2 + (Omega3_4)^2

D3_4 = (2 * Sigma3_4) / qc

E3_4 = 4 + (C3_4) / (qc)^2

G3_4 = sqrt ( (E3_4)^2 -4*(D3_4)^2)

Q3_4 = (1/D3_4) * sqrt( (1/2) * (E3_4 + G3_4) )

k3_4 = (Sigma3_4 * Q3_4) / qc

W3_4 = k3_4 + sqrt((k3_4)^2 -1)

omega01_34 = (1 / W3_4) * omega0

omega02_34 = W3_4 * omega0

%% MONADA 1

%epilegoume tin monada me enisxysi afou Q1_2 > 5

b = 1

c11 = 1

c12 = 1

k1 = ((Q1_2 *3) - 1 ) / (2*Q1_2 - 1)

r1a = 1

r1b = k1-1

kf1 = omega01_12

km1 = 1 / (10^(-8) * kf1)

A1 = 1 / (kf1*km1)

C11 = A1 *c11

C12 = A1 *c12

R11 = km1

R12 = km1

R1A = r1a * 10000

R1B = r1b * 10000
%% MONADA 2

%epilegoume tin monada me enisxysi afou Q1_2 > 5

b = 1

c21 = 1

c22 = 1

k2 = ((Q1_2 *3) - 1 ) / (2*Q1_2 - 1)

r2a = 1

r2b = k2-1

kf2 = omega02_12

km2 = 1 / (10^(-8) * kf2)

A2 = 1 / (kf2*km2)

C21 = A2 *c21

C22 = A2 *c22

R21 = km2

R22 = km2

R2A = r2a * 10000

R2B = r2b * 10000

%% MONADA 3

%epilegoume tin monada me enisxysi afou Q3_4 > 5

b = 1

c31 = 1

c32 = 1

r31 = 1 / sqrt(b)

r32 = sqrt(b)

k3 = ((Q3_4 *(b+2)) - sqrt(b) ) / (2*Q3_4 - sqrt(b))

r3a = 1

r3b = r3a* (k3-1)

kf3 = omega01_34

km3 = 1 / (10^(-8) * kf3)

A3 = 1 / (kf3*km3)

C31 = A3 *c31

C32 = A3 *c32

R31 = km3 * r31

R32 = km3 * r32

R3A = r3a * 10000

R3B = r3b * 10000

%% MONADA 4

%epilegoume tin monada me enisxysi afou Q3_4 > 5

b = 1

c41 = 1

c42 = 1

k4 = ((Q3_4 *3) - 1 ) / (2*Q3_4 - 1)

r4a = 1

r4b = k4-1

kf4 = omega02_34

km4 = 1 / (10^(-8) * kf4)

A4 = 1 / (kf4*km4)

C41 = A4 *c41

C42 = A4 *c42

R41 = km4

R42 = km4

R4A = r4a * 10000

R4B = r4b * 10000

%% transfer function

%T1

a0 = 0;

a1 = 1 / (R11*C11*(1-(1/k1)));

p0 = 1;

p1 = ( (1 / (R12*C11))+(1 / (R12*C12)) - (1 / (R12*C11))*(1 / (k1-1)))

p2 = 1 / (R11*R12*C11*C12);

t1 = tf([a1 a0],[p0 p1 p2]);

%T2

a0 = 0;

a1 = 1 / (R21*C21*(1-(1/k2)));

p0 = 1;

p1 = ( (1 / (R22*C21))+(1 / (R22*C22)) - (1 / (R22*C21))*(1 / (k2-1)));

p2 = 1 / (R21*R22*C21*C22);

t2 = tf([a1 a0],[p0 p1 p2]);

%T3

a0 = 0;

a1 = 1 / (R31*C31*(1-(1/k3)));

p0 = 1;

p1 = ( (1 / (R32*C31))+(1 / (R32*C32)) - (1 / (R32*C31))*(1 / (k3-1)));

p2 = 1 / (R31*R32*C31*C32);

hd_3 = a1 / (omega01_34/Q3_4)

t3 = tf([a1 a0],[p0 p1 p2]);

%T4

a0 = 0;

a1 = 1 / (R41*C41*(1-(1/k4)));

p0 = 1;

p1 = ( (1 / (R42*C41))+(1 / (R42*C42)) - (1 / (R42*C41))*(1 / (k4-1)));

p2 = 1 / (R41*R42*C41*C42);

t4 = tf([a1 a0],[p0 p1 p2]);

% T

t = t1*t2*t3*t4;

%% gain

gain1 = ( ((k1)/((k1-1)*R11*C11))*omega0 ) / (sqrt( (omega01_12^2 - omega0^2)^2 + (omega01_12*omega0/Q1_2)^2))

gain2 = ( ((k2)/((k2-1)*R21*C21))*omega0 ) / (sqrt( (omega02_12^2 - omega0^2)^2 + (omega02_12*omega0/Q1_2)^2))

gain3 = ( ((k3)/((k3-1)*R31*C31))*omega0 ) / (sqrt( (omega01_34^2 - omega0^2)^2 + (omega01_34*omega0/Q3_4)^2))

gain4 = ( ((k4)/((k4-1)*R41*C41))*omega0 ) / (sqrt( (omega02_34^2 - omega0^2)^2 + (omega02_34*omega0/Q3_4)^2))

alpha = 1 / ( (gain1*gain2)*(gain3*gain4)) 

t = (alpha) * t;

%% plots

plot_transfer_function(t1,[f0 f1 f2 f3 f4])

plot_transfer_function(t2,[f0 f1 f2 f3 f4])

plot_transfer_function(t3,[f0 f1 f2 f3 f4])

plot_transfer_function(t4,[f0 f1 f2 f3 f4])

plot_transfer_function(t,[f0 f1 f2 f3 f4])

inverseT = inv(t);

plot_transfer_function(inverseT,[f0 f1 f2 f3 f4])

figure;
bodemag(t1)
hold on 
bodemag(t2)
bodemag(t3)
bodemag(t4)
bodemag(t)
legend('T1(s)','T2(s)','T3(s)','T4(s)','T(s)')
grid on

%% FOURIER ANALYSIS

sys = t;

T = (1.5);

Fs = 1000000;

dt = 1/Fs;

t = 0:dt:T-dt;

x = cos(5419.24*t) + 0.6 *cos(11074.11*t) + cos(2336.97*t) + 0.8*cos(16419.95*t) + 0.4*cos(23945.76*t);

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

axis([0.01 4000 0 inf]);

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

axis([0.01 1500 0 inf]);

title('FFT of Output signal');

syms x

f_1 = sqrt(x+1) + (x^2-2)*log(x+1);
f_2 = (x-2)^2 +cos(x)*cos(x);
f_3 = exp(-3*x) - (sin(x-2)-2)^2;

 size = 100;
k = zeros(size,1); 
l = zeros(size,1);
e = 0.001; 
i = 0;
for lamda = linspace(0.0001,0.1,size)
    i = i + 1
    [a,b,k(i),l(i)] = golden_section(f_1, lamda,0,4);
end
subplot(3,1,1);
plot(l,k+1,'-r','LineWidth',1)
title('$f_1$ = $\sqrt{x+1}$ + $(x^2-2)\cdot ln(x+1)$','Interpreter', 'latex','FontSize',30)
xlabel('Τελικό εύρος αναζήτησης ','FontSize',15) 
ylabel('Υπολογισμοί της αντικειμενικής συνάρτησης','FontSize',10) 


k = zeros(size,1); 
l = zeros(size,1);
e = 0.001; 
i = 0;
for lamda = linspace(0.001,0.1,size)
    i = i + 1
    [a,b,k(i),l(i)] = golden_section(f_2, lamda,0,4);
end
subplot(3,1,2);
plot(l,k+1,'-r','LineWidth',1)
title('$f_2$ = $(x-2)^2$ + $cos^2(x)$','Interpreter', 'latex','FontSize',30)
xlabel('Τελικό εύρος αναζήτησης','FontSize',15) 
ylabel('Υπολογισμοί της αντικειμενικής συνάρτησης','FontSize',10) 

k = zeros(size,1); 
l = zeros(size,1);
e = 0.001; 
i = 0;
for lamda = linspace(0.001,0.1,size)
    i = i + 1
    [a,b,k(i),l(i)] = golden_section(f_3, lamda,0,3);
end
subplot(3,1,3);
plot(l,k+1,'-r','LineWidth',1)
title('$f_3$ = $e^{-3x}$ + $(sin(x-2)-2)^2$','Interpreter', 'latex','FontSize',30)
xlabel('Τελικό εύρος αναζήτησης ','FontSize',15) 
ylabel('Υπολογισμοί της αντικειμενικής συνάρτησης','FontSize',10) 


%% FUNCTION 1


figure;
subplot(3,1,1)
[a,b,k] = golden_section(f_1,0.0021,0,4);

for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
title('$f_1$ = $\sqrt{x+1}$ + $(x^2-2)\cdot ln(x+1)$','Interpreter', 'latex','FontSize',30)
xlabel('l=0.0021','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 

subplot(3,1,2)
[a,b,k] = golden_section(f_1,0.01,0,4);

for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
xlabel('l=0.01','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 

subplot(3,1,3)  
[a,b,k] = golden_section(f_1,0.02,0,4);
for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
xlabel('l=0.02','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 


%% FUNCTION 2

figure;
subplot(3,1,1)
[a,b,k] = golden_section(f_2,0.0021,0,4);

for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
title('$f_2$ = $(x-2)^2$ + $cos^2(x)$','Interpreter', 'latex','FontSize',30)
xlabel('l=0.0021','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 

subplot(3,1,2)
[a,b,k] = golden_section(f_2,0.01,0,4);

for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
xlabel('l=0.01','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 

subplot(3,1,3)  
[a,b,k] = golden_section(f_2,0.02,0,4);
for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
xlabel('l=0.02','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 


%% FUNCTION 3
 
figure;
subplot(3,1,1)
[a,b,k] = golden_section(f_3,0.0021,0,4);

for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
title('$f_3$ = $e^{-3x}$ + $(sin(x-2)-2)^2$','Interpreter', 'latex','FontSize',30)
xlabel('l=0.0021','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 

subplot(3,1,2)
[a,b,k] = golden_section(f_3,0.01,0,4);

for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
xlabel('l=0.01','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 

subplot(3,1,3)  
[a,b,k] = golden_section(f_3,0.02,0,4);
for i=0:1:k-1
    plot(i,a(i+1),'ob')
    hold on
    plot(i,b(i+1),'*r','Color','blue')
end
xlim([0 20])
xlabel('l=0.02','FontSize',20) 
ylabel('[a_k,b_k]','FontSize',20) 
%initialization of time
t=0:0.001:40;
time_step = 0.001;
time_stop = 40;
%input
u = 0.6*sin(5*t)+sin(10*t)+0.6*sin(25*t)+0.6*sin(3*t)+0.6*sin(8*t); 
%output
y=out(t,u);
%flag
position = 1;
format long;
%based on available values to measure
total_values = floor(time_stop/time_step)+1;
for n=1:1:4
for m=0:3
if (n>m)
%chosing lambda-filter parameters
filter_l = filtermaster(n);
%size of phi array
phi_size = n+m+1;
%size of b
b_size = m+1;
%init phi
phi_init=zeros(n*phi_size,1);
%init theta
theta_init=zeros(phi_size,1);
%Q0 array
Q0_notshaped=10^(-17)*eye(phi_size); 
Q0=reshape(Q0_notshaped^(-1),[],1);
%init x
x_init=[phi_init;Q0;theta_init]; 
%initialize estimation of a
estim_a=zeros(total_values,n);
%options=odeset('RelTol', 1e-6,'AbsTol',1e-3);
% ode45
[t,result]=ode45(@(t,result) ode_helper(t,time_step,y,result,n,m,filter_l),t,x_init);
for i=1:1:total_values
estim_a(i,:)=filter_l-result(i,end-n-m:end-m-1);
end
figure;
%plot estimation of a
for i=1:n
    plot(t,estim_a(:,i))
    hold on
end
hold off
title(['a (n=',num2str(n),',m=',num2str(m),')'])
%estimation of b parameters
estim_b=result(:,end-m:end); 
figure;
%plot estimation of b
for i=1:b_size
    plot(t,estim_b(:,i))
    hold on
end
hold off
title(['b (n=',num2str(n),',m=',num2str(m),')'])
%input test
it=sin(t)+cos(2*t)+5*sin(3*t);
%output test
ot=out(t,it);
%final est of a
estim_a_f=filter_l-result(end,end-n-m:end-m-1); 
%final est of b
estim_b_f=result(end,end-m:end);
%estim of parameters
pt=lsim(estim_b_f,[1,estim_a_f],it,t);
%error
err=ot-pt;
figure;
plot(t,err)
title(['error (n=',num2str(n),' ,m=',num2str(m),')'])
%AIC
N=time_stop/time_step+1;
tmp=0;
for i=1:floor(N)
tmp=tmp+err(i)^2;
end
I=tmp/N;
r=2;
k=phi_size; 
onlineAIC(position)=N*log(I) + r*k
position=position+1;
        end
    end
end

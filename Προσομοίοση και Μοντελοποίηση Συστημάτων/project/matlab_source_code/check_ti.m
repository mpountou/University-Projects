t=0:0.001:100;
% elegxos xronika ametavlitou sistimatos
%xroniki kathisterisi
t0=randi([2 4]);
%eisodos u(t)
u=4*sin(4*t)+cos(3*t)+sin(5*t);
%eisodos u(t+t0)
u_t0=4*sin(4*t)+cos(3*t)+sin(5*t);
start_time = t0;
end_time = 100+t0;
t_t0=start_time:0.001:end_time;
%eksodos y(t)
y=out(t,u);
%eksodos y(t+t0)
y_t0=out(t_t0,u_t0);
%sfalma
e=y-y_t0;
%plot
figure
plot(t,e)
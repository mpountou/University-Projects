%% plot function f
figure;
[x,y] = meshgrid(-3:0.1:3);
Z =  x.^3 .* exp(-x.^2-y.^4);
surf(x,y,Z)
colorbar
figure;
%% plot function g
[x,y] = meshgrid(-1.1:0.1:1.1);
Z = x.^4 + y.^2 - 0.2*sin(2*pi*x) - 0.3*cos(2*pi*y);
surf(x,y,Z)
colorbar
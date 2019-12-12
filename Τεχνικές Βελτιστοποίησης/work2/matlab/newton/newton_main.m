%% newton constant f
clear
syms xx yy
f(xx,yy) = xx^3 * exp(-xx^2-yy^4) ;
grad = gradient(f, [xx, yy]) ;
hessi = hessian(f, [xx, yy]) ;

%% calculate for contour (function f)
x_ = -2.5:0.05:2.5;
y_ = x_;
 
pos_x = 0;
for i = x_
    pos_x = pos_x + 1;
    pos_y = 1;
    for j = y_
       z_(pos_y,pos_x) = f(i,j);
       pos_y = pos_y + 1;
    end
end



%% constant values - function f
 
startingPoint  = [0 ; 0];
[x,k, iter] = newton_constant(0.0001,startingPoint,0.7,grad,hessi);
figure;
plot(x(1,:),x(2,:))
a = num2str(iter);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [-1 ; -1];
[x,k, iter] = newton_constant(0.0001,startingPoint,0.7,grad,hessi);
figure;
plot(x(1,:),x(2,:));
a = num2str(iter);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [1 ; 1];
[x,k, iter] = newton_constant(0.0001,startingPoint,0.7,grad,hessi);
figure;
p = plot(x(1,:),x(2,:));
a = num2str(iter);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [-1 ; -0.5];
[x,k, iter] = newton_constant(0.0001,startingPoint,0.7,grad,hessi);
figure;
p = plot(x(1,:),x(2,:));
a = num2str(iter);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar


%% min values - function f

startingPoint  = [-1 ; -0.5];
[x,k, iter] = newton_min(0.0001,startingPoint,f,grad,hessi);
figure;
p = plot(x(1,:),x(2,:));
a = num2str(iter);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$min \enspace \gamma \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar


%% armijo values - function f

startingPoint  = [-1 ; -0.5];
[x,k, iter] = newton_armijo(0.0001,startingPoint,f,grad,hessi);
figure;
p = plot(x(1,:),x(2,:));
a = num2str(iter);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$armijo \enspace \gamma   \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

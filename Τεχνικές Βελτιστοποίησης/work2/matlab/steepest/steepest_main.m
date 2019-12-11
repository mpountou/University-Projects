%% steepest descent - first function
syms x y
f(x,y) = x^3 * exp(-x^2-y^4) ;
grad = gradient(f, [x, y]) ;

%% calculate for contour (function f)
x_ = -3:0.1:3;
y_ = x_;
z_ = zeros(61,61);
pos_x = 0;
for i = x_
    pos_x = pos_x + 1;
    pos_y = 1;
    for j = y_
       z_(pos_x,pos_y) = f(i,j);
       pos_y = pos_y + 1;
    end
end


%% constant values - function f
 
startingPoint  = [0 ; 0];
[x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
figure;
plot(x(1,:),x(2,:))
a = num2str(k-1);
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [-1 ; -1];
[x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
figure;
plot(x(1,:),x(2,:));
a = num2str(k-1);
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [1 ; 1];
[x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
figure;
p = plot(x(1,:),x(2,:));
a = num2str(k-1);
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar
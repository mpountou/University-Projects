%% steepest descent constant f
syms xx yy
% f(xx,yy) = xx^3 * exp(-xx^2-yy^4) ;
% grad = gradient(f, [xx, yy]) ;
% 
% %% calculate for contour (function f)
% x_ = -3:0.1:3;
% y_ = x_;
% z_ = zeros(61,61);
% pos_x = 0;
% for i = x_
%     pos_x = pos_x + 1;
%     pos_y = 1;
%     for j = y_
%        z_(pos_x,pos_y) = f(i,j);
%        pos_y = pos_y + 1;
%     end
% end


%% constant values - function f
 
% startingPoint  = [0 ; 0];
% [x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
% figure;
% plot(x(1,:),x(2,:))
% a = num2str(k-1);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% colorbar
% 
% startingPoint  = [-1 ; -1];
% [x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
% figure;
% plot(x(1,:),x(2,:));
% a = num2str(k-1);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% colorbar
% 
% startingPoint  = [1 ; 1];
% [x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
% figure;
% p = plot(x(1,:),x(2,:));
% a = num2str(k-1);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% colorbar














%% steepest descent constant g






clear
syms xx yy
f(xx,yy) = xx^4 + yy^2 - 0.2*sin(2*pi*xx) - 0.3*cos(2*pi*yy) ;
grad = gradient(f, [xx, yy]) ;

%% calculate for contour (function f)
from_ = -1.1;
to_ = 1.1;
x_ = from_:0.1:to_;
y_ = from_:0.1:to_;

cx = 0;
for i = x_
    cx = cx + 1;
    cy = 1;
    for j = y_
       z_(cx,cy) = f(i,j);
       cy = cy + 1;
    end
end

%% constant values - function g

startingPoint  = [0 ; 0];
[x,k] = steepest_constant(0.0001,startingPoint,0.1,grad);
figure;
plot(x(1,:),x(2,:))
a = num2str(k-1);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.1 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar
caxis([-1 2.5])


startingPoint  = [-1 ; -1];
[x,k] = steepest_constant(0.0001,startingPoint,0.1,grad);
figure;
plot(x(1,:),x(2,:))
a = num2str(k-1);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.1 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar
caxis([-1 2.5])


startingPoint  = [1 ; 1];
[x,k] = steepest_constant(0.0001,startingPoint,0.1,grad);
figure;
plot(x(1,:),x(2,:))
a = num2str(k-1);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.1 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar
caxis([-1 2.5])
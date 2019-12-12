%% steepest descent constant f
clear
syms xx yy
f(xx,yy) = xx^3 * exp(-xx^2-yy^4) ;
grad = gradient(f, [xx, yy]) ;

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
[x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
figure;
plot(x(1,:),x(2,:))
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [-1 ; -1];
[x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
figure;
plot(x(1,:),x(2,:));
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar

startingPoint  = [1 ; 1];
[x,k] = steepest_constant(0.0001,startingPoint,0.7,grad);
figure;
p = plot(x(1,:),x(2,:));
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$constant \enspace \gamma = 0.7 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar



%% steepest descent min f

startingPoint  = [0 ; 0];
[x,k] = steepest_min(0.0001,startingPoint,f,grad);
figure;
plot(x(1,:),x(2,:))
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$min \enspace f(x_k+g_k \cdot d_k ) \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar




startingPoint  = [-1 ; -1];
[x,k] = steepest_min(0.0001,startingPoint,f,grad);
figure;
plot(x(1,:),x(2,:))
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$min \enspace f(x_k+g_k \cdot d_k ) \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar


startingPoint  = [1 ; 1];
[x,k] = steepest_min(0.0001,startingPoint,f,grad);
figure;
plot(x(1,:),x(2,:))
a = num2str(k-1);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$min \enspace f(x_k+g_k \cdot d_k ) \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar


%% steepest descent armijo

startingPoint  = [0 ; 0];
[x,k] = steepest_armijo(0.0001,startingPoint,f,grad);
figure;
plot(x(1,:),x(2,:))
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$armijo \enspace step \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar




startingPoint  = [-1 ; -1];
[x,k] = steepest_armijo(0.0001,startingPoint,f,grad);
figure;
plot(x(1,:),x(2,:))
if k>1
a = num2str(k-1);
else
 a = num2str(1); 
end
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$armijo \enspace step \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar


startingPoint  = [1 ; 1];
[x,k] = steepest_armijo(0.0001,startingPoint,f,grad);
figure;
plot(x(1,:),x(2,:))
a = num2str(k-1);
x_1 = num2str(x(1,k));
x_2 = num2str(x(2,k));
f_min = num2str(double(f(x(1,k),x(2,k))));
title(['$armijo \enspace step \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace f(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
hold on
contour(x_, y_, z_)
colorbar


% clear
% syms xx yy
% f(xx,yy) = xx^4 + yy^2 - 0.2*sin(2*pi*xx) - 0.3*cos(2*pi*yy) ;
% grad = gradient(f, [xx, yy]) ;

%% calculate for contour (function f)
% from_ = -1.1;
% to_ = 1.1;
% x_ = from_:0.1:to_;
% y_ = from_:0.1:to_;
% z_ = zeros(23,23);
% cx = 0;
% for i = x_
%     cx = cx + 1;
%     cy = 1;
%     for j = y_
%        z_(cx,cy) = f(i,j);
%        cy = cy + 1;
%     end
% end

%% constant values - function g

% startingPoint  = [0 ; 0];
% [x,k] = steepest_constant(0.0001,startingPoint,0.1,grad);
% figure;
% plot(x(1,:),x(2,:))
% a = num2str(k-1);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$constant \enspace \gamma = 0.1 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace g(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% colorbar
% caxis([-1 2.5])
% 
% 
% startingPoint  = [-1 ; -1];
% [x,k] = steepest_constant(0.0001,startingPoint,0.1,grad);
% figure;
% plot(x(1,:),x(2,:))
% a = num2str(k-1);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$constant \enspace \gamma = 0.1 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace g(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% colorbar
% caxis([-1 2.5])
% 
% 
% startingPoint  = [1 ; 1];
% [x,k] = steepest_constant(0.0001,startingPoint,0.1,grad);
% figure;
% plot(x(1,:),x(2,:))
% a = num2str(k-1);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$constant \enspace \gamma = 0.1 \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace g(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% colorbar
% caxis([-1 2.5])




%% steepest descent min g

% startingPoint  = [0 ; 0];
% [x,k] = steepest_min(0.00001,startingPoint,f,grad);
% figure;
% plot(x(1,:),x(2,:))
% if(k ==1)
%     k = k+1;
% else
%     q = k;
% end
% a = num2str(q);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$min \enspace g(x_k+g_k \cdot d_k ) \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace g(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% 
% 
% startingPoint  = [-1 ; -1];
% [x,k] = steepest_min(0.00001,startingPoint,f,grad);
% figure;
% plot(x(1,:),x(2,:))
% if(k ==1)
%     q = k+1;
% else
%     q = k;
% end
% a = num2str(q);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$min \enspace g(x_k+g_k \cdot d_k ) \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace g(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)
% 
% 
% 
% startingPoint  = [1 ; 1];
% [x,k] = steepest_min(0.00001,startingPoint,f,grad);
% figure;
% plot(x(1,:),x(2,:))
% if(k ==1)
%     q = k+1;
% else
%     q = k;
% end
% a = num2str(q);
% x_1 = num2str(x(1,k));
% x_2 = num2str(x(2,k));
% f_min = num2str(double(f(x(1,k),x(2,k))));
% title(['$min \enspace g(x_k+g_k \cdot d_k ) \enspace with \enspace iterations = $' a '\enspace at \enspace point (' x_1 ',' x_2 ') \enspace with \enspace value \enspace g(x,y)=' f_min],'Interpreter', 'latex','FontSize',25)
% hold on
% contour(x_, y_, z_)






function [x_result, k] = steepest_constant( e, startingPoint, gamma,grad)
% number of steps
k = 1;
% starting point
x_result(: ,k) = startingPoint;
% calculate gradient of function
dif_f(:,k) = grad(x_result(1,k),x_result(2,k));
% set accuracy
epsilon = e;
while norm(dif_f(:,k))>=epsilon
    x_result(:,k+1) = x_result(:,k)-(gamma*dif_f(:,k));
    dif_f(:,k+1) = grad(x_result(1,k+1),x_result(2,k+1));
    k = k + 1;
    if(k > 1000)
        disp('too much steps... aborting')
        break
    end
end
% display min
x_result(:,k)
end
 
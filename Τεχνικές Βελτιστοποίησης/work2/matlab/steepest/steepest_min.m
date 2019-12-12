function [x_end,k] = steepest_min( e,startingPoint,f,gradf )
k=1;
x_end(:,k)=startingPoint;
grad(:,k)=gradf(x_end(1,1),x_end(2,1));
epsilon=e;
while norm(grad(:,k))>=epsilon 
    gama=gamaMin([grad(1,k) grad(2,k)],[x_end(1,k) x_end(2,k)],f);
    x_end(:,k+1)=x_end(:,k)-(gama*grad(:,k));
    grad(:,k+1)=gradf(x_end(1,k+1),x_end(2,k+1));
    k = k + 1;
    if(k>500)
        disp('too much steps... aborting')
        break
    end
end
if k >1
k = k-1;
 
end
end

function gamma = gamaMin( grad_current,x_current,f)
fun = @(gamma) f(x_current(1) - gamma * grad_current(1), x_current(2) - gamma * grad_current(2));
gamma = fminsearch(fun,0.1);
end



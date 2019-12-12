function [ x_end,k, iter ] = newton_constant(  e, startingPoint, g, gradF ,hessian )
k = 1;
x_end(: ,k) = startingPoint;
grad(:,k) = gradF(x_end(1,k),x_end(2,k));
epsilon = e;
gama=g;
iter = 0;

while norm(grad(:,k))>=epsilon
    iter = iter+1;  
    a=checkPositiveDefinite(hessian(x_end(1,k),x_end(2,k)),iter);
    if(a==0)
        break;
    end
    d(:,k)=(-inv(hessian(x_end(1,k),x_end(2,k)))*(gradF(x_end(1,k),x_end(2,k))));
    x_end(:,k+1) = x_end(:,k)+(gama*d(:,k));
    grad(:,k+1) = gradF(x_end(1,k+1),x_end(2,k+1));
    k = k + 1;
    
    if(k > 1000)
        disp('too many steps... aborting')
        break
    end
    

end
end

function x=checkPositiveDefinite(A,iter)

    [m,n]=size(A); 
    if m~=n,
        error('A is not Symmetric');
    end
      
    x=1; 
    for i=1:m
        subA=A(1:i,1:i); 
        if(det(subA)<=0);  
            x=0;
            break;
        end
    end
    
    if x
        display('Given Matrix is positive definite');
        iter
    else
        display('Given Matrix is not positive definite');
        iter
    end      
end






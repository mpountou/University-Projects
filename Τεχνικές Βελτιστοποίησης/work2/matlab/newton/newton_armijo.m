function [ x_end,k, iter ] = newton_min(  e, startingPoint, f, gradF ,hessian )
k = 1;
x_end(: ,k) = startingPoint;
grad(:,k) = gradF(x_end(1,k),x_end(2,k));
epsilon = e;
 
iter = 0;

while norm(grad(:,k))>=epsilon
    iter = iter+1;  
    a=checkPositiveDefinite(hessian(x_end(1,k),x_end(2,k)),iter);
    if(a==0)
        break;
    end
    d(:,k)=(-inv(hessian(x_end(1,k),x_end(2,k)))*(gradF(x_end(1,k),x_end(2,k))));
    
    gama= armijo_gamma(x_end,k,f,gradF);
    
    x_end(:,k+1) = x_end(:,k)+(gama*d(:,k));
    
    grad(:,k+1) = gradF(x_end(1,k+1),x_end(2,k+1));
    k = k + 1;
    
    if(k > 1000)
        disp('too many steps... aborting')
        break
    end
    

end
end


function [ gamma ] = armijo_gamma( x ,k,f,grad)

v1=x(:,k);

beta=0.5;rho=0.2;  

m=1;mmax=20;

while(m<mmax) 
    
    gk=double(grad(double(v1(1,1)),double(v1(2,1))));
    
    dk=double(-gk);
     
    v2=double(v1+(beta^m)*dk) ;
   
    if  double(f(double(v2(1,1)),double(v2(2,1))))  <=    double(f(double(v1(1,1)),double(v1(2,1)))+rho*(beta^m)*gk*dk')
       
        gamma=beta^m;return;  
       
    end
    
    v1=double(v2);
    m=m+1;
 
end

gamma=beta^m; 
 
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






function [x_end,k] = steepest_armijo( e,startingPoint,f,gradf )
k=1;
x_end(:,k)=startingPoint;
grad(:,k)=gradf(x_end(1,1),x_end(2,1));
epsilon=e;
while norm(grad(:,k))>=epsilon 
  
    
    gamma=armijo_gamma(x_end,k,f,gradf);  
    
    x_end(:,k+1)=x_end(:,k)-(gamma*grad(:,k));
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

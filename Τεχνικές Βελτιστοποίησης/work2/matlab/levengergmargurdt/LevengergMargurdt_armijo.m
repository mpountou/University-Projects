function [ x, k ] = LevengergMargurdt_armijo(  epsilon, xStart, f, gradFun, hessian)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%   Detailed explanation goes here
k = 1;
x(: ,k) = xStart;
grad(:,k) = gradFun(x(1,k),x(2,k));
iter = 0;

while norm(grad(:,k))>=epsilon
    iter = iter+1;
    h=hessian(x(1,k),x(2,k));
    m(k)=max(abs(eig(h)))*1.06;
    par=h+(m(k)*eye(2,2));
    d(:,k)=par\(-grad(:,k));
    disp(d(:,k))
    gamma = armijo_gamma(x,k,f,gradFun);
    x(:,k+1) = x(:,k)+gamma* d(:,k)
    grad(:,k+1) = gradFun(x(1,k+1),x(2,k+1));
    k = k + 1;
    if(k > 100000)
        disp('the algorithm is very slow cause the grad(x(k),y(k)) is very big,stop in 100000 iteration')
        break
    end
  
end
end




function [ gamma ] = armijo_gamma(x,k,f,grad)

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


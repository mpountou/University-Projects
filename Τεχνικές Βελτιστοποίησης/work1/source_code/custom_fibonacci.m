function [a,b,k,l_]= custom_fibonacci( f,l,a1,b1)
b=b1;
a=a1;
k=1;
l_ = l;
fibon(1)=0.382;
fibon(2)=0.618;
a(k)=a1;
b(k)=b1;
j=2;
    while(fibon(j)<=(b1-a1)/l)
        j=j+1;
        fibon(j)=fibon(j-1)+fibon(j-2);
           
    end 
    n=length(fibon);
    x1(k)=a(k)+(fibon(n-k-1)/fibon(n-k+1))*(b(k)-a(k));
    x2(k)=a(k)+(fibon(n-k)/fibon(n-k+1))*(b(k)-a(k));
    y1(k)=subs(f,x1);
    y2(k)=subs(f,x2);
    while(b(k)-a(k)>=l)
        if(k >= n-3)
            break;
        end
        
        if(y1(k)<y2(k))
            a(k+1) = a(k);
            b(k+1) = x2(k) ;
            x2(k+1) = x1(k) ;
            x1(k+1) = a(k+1) + fibon(n-k-2) / fibon(n-k) * ( b(k+1) - a(k+1) ) ;
            y2(k+1) = y1(k) ;
            y1(k+1) = subs(f,x1(k+1));
            
        else
            a(k+1) = x1(k) ;
            b(k+1) = b(k) ;
            x1(k+1) = x2(k) ;
            x2(k+1) = a(k+1) + fibon(n-k-1) / fibon(n-k) * ( b(k+1) - a(k+1) ) ;
            y1(k+1) = y2(k) ;
            y2(k+1) = subs(f,x2(k+1)) ;
            
        end
        k=k+1;
    end
       
end



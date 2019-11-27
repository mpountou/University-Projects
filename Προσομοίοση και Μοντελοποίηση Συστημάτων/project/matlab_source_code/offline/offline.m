%time 
t = 0:0.001:30;
%selected input
u = cos(t)+0.1*sin(t);
%selected output
y = out(t,u);
%tested input
utest = cos(t)+0.1*sin(t)+cos(3*t)+1.1*sin(5*t);
%tested input
ytest = out(t,utest);
%init pos
position = 1;
%loop for m,n
for n = 1:1:4
    for m = 0:1:3
        %stability check
        if(n>m)
        %filtermaster helps to choose correct filter
        l = filtermaster(n);
        %array of fi
        fi = calcmaster(n,m,y,u,t,l);
        %least squares in parts
        part1 = ( fi * (fi.') ) ^ ( - 1);  
        part2 = fi * y ;
        %calculating theta
        theta = part1 * part2;
        %output estimation
        est = (theta.') * fi;
        %error
        error = y - est.';
        %ploting..
        figure;
        plot(t,error);
        legend(['n= ' num2str(n) ' and m= ' num2str(m)])
        set(legend,'Interpreter','latex') 
        %calculating AIC error in offline
        for i= 1:1:n
        theta(i,1) = l(1,i+1) + theta(i,1);
        end
         a_end = zeros(1,n);
        for i = 1:1:n 
            a_end(1,i) = theta(i,1);
        end
         b_end = zeros(1,m+1);
         inc = 0;
        for i = (n+1):1:(n+m+1) 
            inc = inc + 1;
            b_end(1,inc) = theta(i,1);
        end
    
        yytest=lsim(b_end,[1,a_end],utest,t);
        newerror = ytest - yytest;
        N=30/0.001+1;
        tmp=0;
        for i=1:floor(N)
        tmp=tmp+newerror(i)^2;
        end
        I=tmp/N;
        r=2;
        k=m+n+1; 
        %AIC CALCULATION
        offlineAIC(position)=N*log(I) + r*k;
        position=position+1;
        end
    end
end
%those are just to show correct parameters
%.....
%.....
l = filtermaster(3);
fi = calcmaster(3,2,y,u,t,l);
part1 = ( fi * (fi.') ) ^ ( - 1);  
part2 = fi * y ;
theta = part1 * part2;
theta(1,1) = theta(1,1) + 4;
theta(2,1) = theta(2,1) + 5;
theta(3,1) = theta(3,1) + 2;
theta
%.....
%.....


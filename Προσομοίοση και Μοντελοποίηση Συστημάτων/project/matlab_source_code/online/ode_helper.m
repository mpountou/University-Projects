function returnfunc = ode_helper(t,time_step,y,x,n,m,filter_l)

time_estim = floor(t/time_step+1);

fi_size = n+m+1;

input=0.6*sin(5*t)+sin(10*t)+0.6*sin(25*t)+0.6*sin(3*t)+0.6*sin(8*t); 

output=y(time_estim);

fi_d=[1,filter_l];

gr_b=0.0001;

fi_n=zeros(1,n); 

outputC=zeros(n,n);

outputD=zeros(1,n);

outputfi=zeros(n,n);

for i=1:n
    fi_n(i)=1;
    
    [A,B,outputC(:,i),outputD(i)]=tf2ss(fi_n,fi_d);
    
    outputfi(:,i)=A*x((i-1)*n+1:(i-1)*n+n)+B*output;
    
    fi_n=zeros(1,n);
end

inputC=zeros(n,m+1); 

inputD=zeros(1,m+1);

inputfi=zeros(1,m+1); 

inputdotfi=zeros(n,m+1); 

for i=1:m+1
    inputfi(i)=1;
    
    [A,B,inputC(:,i),inputD(i)]=tf2ss(inputfi,fi_d);
    
    inputdotfi(:,i)=A*x(n*n+(i-1)*n+1:n*n+(i-1)*n+n)+B*input;
    
    inputfi=zeros(1,m+1);
end

dotfi=reshape([outputfi,inputdotfi],[],1); 

for i=1:n
    fi_output(i)=outputC(:,i).'*x((i-1)*n+1:(i-1)*n+n)+outputD(i)*output;
end    

for i=1:m+1
    fi_input(i)=inputC(:,i).'*x(n*n+(i-1)*n+1:n*n+(i-1)*n+n)+inputD(i)*input;
end 

fi=[fi_output.';fi_input.']; 

P=zeros(fi_size,fi_size);

for i=1:fi_size
    for j=1:fi_size
       P(j,i)= x(n*(fi_size)+(i-1)*(fi_size)+j); 
    end    
end

idP=gr_b*P-P*(fi*fi.')*P; 

dotP=reshape(idP,[],1);

dtheta=P*fi*(output-fi.'*x(n*(fi_size)+(fi_size)^2+1:n*(fi_size)+(fi_size)^2+fi_size));

returnfunc=[dotfi;dotP;dtheta];
    
end
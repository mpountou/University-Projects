function [x_end,k,iter] = LevengergMargurdt_min(epsilon,startPoint,f,gradf,hessianf)

k = 1; 

STEP_MAX = 2000;

point_x = startPoint(1,1); 

point_y = startPoint(2,1);

lamda = 10 * epsilon /4 ; 

alpha = 0; 

beta = 4;

while ( norm(gradf(point_x(k),point_y(k))) > epsilon && k <= STEP_MAX)
   
    hessian = hessianf(point_x(k),point_y(k));
    
    eigen = eig(hessian);
    
    m = abs(max(eigen));
   
    [~,p] = chol(hessian + m * eye(2));
    
    while p>0  
        
        m = m + 0.1;
        
        [~,p] = chol(hessian + m * eye(2));
        
    end
    
    d = - inv(hessian + m * eye(2)) * gradf(point_x(k),point_y(k));
    
    h = @(g)f(point_x(k) + g*d(1,1),point_y(k) + g*d(2,1));
    
    g = golden_section(h,lamda,alpha,beta);
 
    if criteria_testing(g,d,k,point_x,point_y,gradf,f,hessianf)
        
        point_x(k+1) = point_x(k) + g * d(1,1);
        
        point_y(k+1) = point_y(k) + g * d(2,1);
    else
        
        error('Error')
        
    end
    
    k = k + 1;
    
end

x_end = [point_x ; point_y];

iter = k;

end




function [criteria_flag] = criteria_testing(g,d,k,point_x,point_y,gradf,f,hessianf)

point_x(k+1) = point_x(k) + g * d(1,1);

point_y(k+1) = point_y(k) + g * d(2,1);

criteria_flag = false;    

z_1 = transpose(d) * gradf(point_x(k+1),point_y(k+1));

z_2 = transpose(d) * gradf(point_x(k),point_y(k));

for beta = linspace(0.1,1,30)
    
    if  z_1> beta * z_2
  
        w_1 = f(point_x(k+1),point_y(k+1));
        
        w_2 = f(point_x(k),point_y(k));
        
        w_3 = g * transpose(d) * gradf(point_x(k+1),point_y(k+1));

        for alpha = linspace(0.00001,beta,30)
            
            if w_1 <= w_2 + alpha * w_3
                
                criteria_flag = true;
         
                break;
            end
        end
        break;
    end
end
end



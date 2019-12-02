function [a_k,b_k,k,l] = bisectionDivAlgorithm(df,lamda,a_,b_)

k = 1; 
a_k = []; 
b_k= []; 
n = 0; 
l = lamda;
a_k(k) = a_; 
b_k(k) = b_;

while( n<log2((b_k(k) - a_k(k))/ l))
    n = n +1;
end

for z = 1:n-1
    x_1 = ( a_k(z) + b_k(z) )/2;
    di = subs(df,x_1);
    
    if di == 0
        return
    elseif di > 0
        a_k(z+1) = a_k(z);
        b_k(z+1) = x_1;
    elseif di < 0
        a_k(z+1) = x_1;
        b_k(z+1) = b_k(z);
    end
    k = k+1;
end

end
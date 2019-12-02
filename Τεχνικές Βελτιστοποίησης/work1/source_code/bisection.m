function [a_k,b_k,k,e_,l_] = bisection(f,e,l,a,b)
% initialize step
k = 1;
e_ = e;
l_ = l;
% initialize range of search
a_k(1,1) = a;
b_k(1,1) = b;
% bisection algorith starts here
while b_k(1,k) - a_k(1,k) >= l
    x1_k = ( a_k(1,k) + b_k(1,k) ) / 2 - e;
    x2_k = ( a_k(1,k) + b_k(1,k) ) / 2 + e;
    k = k+1;
        if subs(f,x1_k) < subs(f,x2_k)
        a_k(1,k) = a_k(1,k-1);
        b_k(1,k) = x2_k;
        else
        a_k(1,k) = x1_k;
        b_k(1,k) = b_k(1,k-1);
        end
end

end
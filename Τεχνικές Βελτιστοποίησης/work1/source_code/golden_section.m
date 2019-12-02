function [a_k,b_k,k,l_] = golden_section(f,l,a,b)
a_k(1,1) = a;
b_k(1,1) = b;
k = 1;
l_ = l;
gamma = 0.618;
x1k(1,1) = a_k(1,1) + (1-gamma)*(b_k(1,1)-a_k(1,1));
x2k(1,1) = a_k(1,1) + gamma * (b_k(1,1)-a_k(1,1));
while b_k(1,k)-a_k(1,k) >= l
    fx1k(1,k) = subs(f,x1k(1,k));
    fx2k(1,k) = subs(f,x2k(1,k));
    if fx1k(1,k) > fx2k(1,k)
    a_k(1,k+1) = x1k(1,k);
    b_k(1,k+1) = b_k(1,k);
    x2k(1,k+1) = a_k(1,k+1) + gamma * (b_k(1,k+1) - a_k(1,k+1));
    x1k(1,k+1) = x2k(1,k);
    k = k+1;
    elseif fx1k(1,k) < fx2k(1,k)
      a_k(1,k+1) = a_k(1,k);
      b_k(1,k+1) = x2k(1,k);
      x2k(1,k+1) = x1k(1,k);
      x1k(1,k+1) = a_k(1,k+1) + (1-gamma)*(b_k(1,k+1) - a_k(1,k+1));
      k = k+1;
    end  
end
end
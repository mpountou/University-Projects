function [ output_args ] = calcmaster( n,m,y,u,t,l )
 c = 0;
 fi = zeros((n+m+1), size(t,2) );
 for i = n:-1:1
 c = c + 1;
 A_z = zeros(1,i);
 A_z(1,1) = -1;
 B_z = l;
 z = lsim(A_z,B_z,y,t);
 z = z.';
 fi(c,:) = z;
 end
 for j = m:-1:0
 c=c+1;
 A_z = zeros(1,j+1);
 A_z(1,1) = 1;
 B_z = l;
 z = lsim(A_z,B_z,u,t);
 z = z.';
 fi(c,:) = z;
 end
 output_args = fi;
end


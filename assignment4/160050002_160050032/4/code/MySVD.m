function [U,S,V] = MySVD(A)
[m,n] = size(A);
M_1 = A*A'; % m*m
M_2 = A'*A; % n*n

[U1,D_11] = eig(M_1);
[V1,D_22] = eig(M_2);
[U,D_1]=sortem(U1,D_11);
[V,D_2]=sortem(V1,D_22);
 
 S = zeros(m,n);
 % fill S with square root of eigen values
 if(m < n)
     for(i = 1:min(m,n))
         S(i,i) = sqrt(D_1(i,i));
     end   
 end
 if(m >= n)
     for(i = 1:min(m,n))
         S(i,i) = sqrt(D_2(i,i));
     end
 end



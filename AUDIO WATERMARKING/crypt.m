%crypt(M,N,e) 
function mc = crypt(M,N,e)                  %declare a function named crypt with input arguments M,N and e and output mc
e=dec2bin(e);                               %convert dec to binary string
k = 65535;
c  = M;
cf = 1;
cf=mod(c*cf,N);
for i=k-1:-1:1
    c = mod(c*c,N);
    j=k-i+1;
     if e(j)==1
         cf=mod(c*cf,N);
     end
end
mc=cf;

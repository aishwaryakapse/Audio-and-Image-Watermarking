function [I1]=two_D(I,R,C)
c=1;
for i=1:R
    for j=1:C
        I1(i,j)=I(1,c);
        c=c+1;
    end
end
        
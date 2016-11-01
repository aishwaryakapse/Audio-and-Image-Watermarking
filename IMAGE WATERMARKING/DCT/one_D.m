function [I]=one_D(I1,R,C)
c=1;
for i=1:R
    for j=1:C
        I(1,c)=I1(i,j);
        c=c+1;
    end
end
        
function [mse psnr] = parameter(pic1,pic2)
%Performance parameters
e=0;
[m,n,f]=size(pic1);
for i=1:m
    for j=1:n
        for k=1:f
        e=e+double((pic1(i,j,k)-pic2(i,j,k)).^2);
        end
    end
end
mse=e/(m*n*f);
m=max(max(max(pic1)));
psnr=10*log(double(m)^2/double(mse));



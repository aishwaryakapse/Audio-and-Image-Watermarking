%IMAGE WATERMARKING USING DWT
tic;
clc;
close all;
clear all;
%Get original image
[fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Base Image');
img=imread([pthname_o fname_o]);
img=imresize(img,[512 512]);
img=double(img);
c=0.01;                                                 %initialise the weight of watermarking
subplot(2,2,1);
imshow(uint8(img));
title('BASE IMAGE');
[p q r]=size(img);
p1=p;
q1=q; 
%Select the watermark image
[fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Watermark Image');
n=imread([pthname_o fname_o]);
watermark=imresize(n,[p/2 q/2]);
watermark=double(watermark);
subplot(2,2,2);
imshow(uint8(watermark));
title('WATERMARK IMAGE');
p=p/4;q=q/4;
for k=1:r
    [ca,ch,cv,cd]=dwt2(img(:,:,k),'db1');               %compute the wavelet transform L1
    [caa,cha,cva,cda]=dwt2(ca,'db1');                   %compute the wavelet transform L2
    %perform watermarking
    y=[caa cha;cva cda];
    Y=y+c*watermark(:,:,k);
    for i=1:p
        for j=1:q
            ncaa(i,j)=Y(i,j);
            ncva(i,j)=Y(i+p,j);
            ncha(i,j)=Y(i,j+q);
            ncda(i,j)=Y(i+p,j+p);
        end
    end
    %display the watermarked image
    d1=idwt2(ncaa,ncha,ncva,ncda,'db1');
    wimg(:,:,k)=(idwt2(d1,ch,cv,cd,'db1'));
    y1(:,:,k)=y;
end
subplot(2,2,3);
imshow(uint8(wimg));title('2-LEVEL DWT WATERMARKED IMAGE');

%%%%%%%%%%%%%%%%EXTRACTION%%%%%%%%%%%%%%%%%%

for k=1:r
    [rca,rch,rcv,rcd]=dwt2(wimg(:,:,k),'db1');
    [rcaa,rcha,rcva,rcda]=dwt2(rca,'db1');
    n1(:,:,k)=[rcaa,rcha;rcva,rcda];
    N1(:,:,k)=n1(:,:,k)-y1(:,:,k);
    N1(:,:,k)=N1(:,:,k)/c;
end
subplot(2,2,4);
imshow(uint8(N1)),title('EXTRACTED IMAGE');

%Display Performance Parameters
[mse psnr]=parameter(wimg,img);
disp(['MSE:',num2str(mse)]);
disp(['PSNR:',num2str(psnr)]);
toc;
%IMAGE WATERMARKING USING DCT
tic;
clc;
clear all;
close all; 
%Select The Base Image
[fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Original Image');
originalImage=imread([pthname_o fname_o]);
watermarkedImage=zeros(512,512);
I=imresize(originalImage,[512 512]);
inputImage= im2double(I);
[R C r]=size(inputImage);
subplot(2,3,1);
imshow(inputImage);
title('BASE IMAGE');
%Select the watermark image
[fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Watermark Image');
watermark=imread([pthname_o fname_o]);
%watermark=imresize(watermark,[256 256]);
[R1 C1 r1]=size(watermark);
watermarkImage=im2double(watermark);
subplot(2,3,2);
imshow(watermark);
title('WATERMARK IMAGE');

alpha=0.03;                 %weighing factor
k1=ceil((R1*C1)/(64*64));   %Embedding Proportion
%perform Embedding in DCT domain
for x=1:r
    w=one_D(watermarkImage(:,:,x),R1,C1);
    Y=length(w);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=inputImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=one_D(f,8,8);
            for k=1:k1
                if count<=Y
                    f1(1,k+10)=w(1,count)*alpha;
                    count=count+1;
                end
            end
            out1=two_D(f1,8,8);
            out=idct2(out1);
            watermarkedImage(r1:r2,c1:c2,x)=out;
            c1=c1+8;
            c2=c2+8;
        end
        r1=r1+8;
        r2=r2+8;
        c1=1;c2=8;
    end 
    res(:,:,x)=im2uint8(watermarkedImage(:,:,x));
end
subplot(2,3,4);
imshow(res);
title('IMAGE AFTER WATERMARKING');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %WATERMARK EXTRACTION
for x=1:r
    W1=zeros(R1,C1);
    w=one_D(W1,R1,C1);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=watermarkedImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=one_D(f,8,8);
            for k=1:k1
                if count<=(R1*C1)
                    w(1,count)=f1(1,k+10)/alpha;
                    count=count+1;
                end
            end
            c1=c1+8;
            c2=c2+8;
        end
        r1=r1+8;
        r2=r2+8;
        c1=1;c2=8;
    end
     op(:,:,x)=im2uint8(two_D(w,R1,C1));
end
subplot(2,3,5);
imshow(op);
title('EXTRACTED WATERMARK');
%Display Performance Parameters
[mse psnr]=parameter(res,I);
disp(['MSE:',num2str(mse)]);
disp(['PSNR:',num2str(psnr)]);
toc;
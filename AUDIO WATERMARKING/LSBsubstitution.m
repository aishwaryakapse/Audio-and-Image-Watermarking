%LSB Substitution
function [ex_cipher original_audio watermarked_audio mse psnr] = LSBsubstitution(t)
%Select the audio file
[fname pathname]=uigetfile('*.wav');
original_audio=wavread([ pathname fname]);[r c]=size(t);
n=input('Enter the no of LSB bits to be replaced: ');
rt=1;ct=1;
ce=1;re=1;
length_original=length(original_audio);
%Embedding and Extraction
for i=1:length_original
    if original_audio(i)>=0
       a1(i)=original_audio(i)*10000;
       p=ceil(a1(i));
       b=de2bi(p);
       c1=[b,zeros(1,(16-length(b)))];
       new_c1=c1;
       for j=1:n
           if rt>r &&ct>c
               break;
           elseif ct<=c&&rt<=r
           new_c1(1,j)=t(rt,ct);
           ct=ct+1;
           end;
           if ct>c
               rt=rt+1;
               ct=1;
           end
       end
       for j=1:n
           if re>r &&ce>c
               break;
           elseif ce<=c&&re<=r
          t2(re,ce)=new_c1(1,j);
           ce=ce+1;
           end;
           if ce>c
               re=re+1;
               ce=1;
           end
       end
       d=(bi2de(new_c1));
       l=d;
        
    elseif  original_audio(i)<0
       a1(i)=original_audio(i)*10000;
       p=ceil(a1(i));
       b=de2bi(2^14+p);
       c1=[b,zeros(1,(16-length(b)))];
       new_c1=c1;
           
       for j=1:n
           if rt>r&&ct>c
               break;
           elseif ct<=c&&rt<=r
           new_c1(1,j)=t(rt,ct);
           ct=ct+1;
           end
           if ct>c
               rt=rt+1;
               ct=1;
           end
       end
       for j=1:n
           if re>r &&ce>c
               break;
           elseif ce<=c&&re<=r
          t2(re,ce)=new_c1(1,j);
           ce=ce+1;
           end;
           if ce>c
               re=re+1;
               ce=1;
           end
       end

       d=(bi2de(new_c1));
       l=d-2^14;
    end
   watermarked_audio(i)=l*0.0001;
end
ex_cipher=bi2de(t2);
 
%Performance parameters
length_watermark=length(watermarked_audio);
sum=0;
for i=1:length_watermark
    sum=sum+(original_audio(i)-watermarked_audio(i)).^2;
end
mse=sum/length_watermark;

alpha=max(watermarked_audio);
psnr=10*log10((alpha^2)/mse);      
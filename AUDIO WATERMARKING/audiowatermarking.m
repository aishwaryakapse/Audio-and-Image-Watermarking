%Main Program.
tic;
clc;
close all;
clear all;

disp('AUDIO WATERMARKING USING LSB SUBSTITUTION');
disp('Enter prime numbers in the range: 50-9749');
p = input('\nEnter the value of p: ');
q = input('\nEnter the value of q: ');
disp('Intializing:');
N=p*q;
Phi=(p-1)*(q-1);

%Calculate the value of e
x=2;e=1;
while x > 1
    e=e+1;
    x=gcd(Phi,e);
end
%Calculate the value of d
i=1;
r=1;
while r > 0
    k=(Phi*i)+1;
    r=rem(k,e);
    i=i+1;
end
d=k/e;
%Display all parameters
disp(['The value of (p) is: ' num2str(p)]);
disp(['The value of (q) is: ' num2str(q)]);
disp(['The value of (N) is: ' num2str(N)]);
disp(['The public key (e) is: ' num2str(e)]);
disp(['The value of (Phi) is: ' num2str(Phi)]);
disp(['The private key (d)is: ' num2str(d)]);

%Convert characters into their ASCII values
M = input('\nEnter the message: ','s');
x=length(M);
c=0;
for j= 1:x
    for i=0:122
        if strcmp(M(j),char(i))
            c(j)=i;
        end
    end
end
disp('ASCII Code of the entered Message:');
disp(c); 

% % %Encryption
for j= 1:x
   cipher(j)=crypt(c(j),N,e); 
end
disp('Cipher Text of the entered Message:');
disp(cipher);
t=de2bi(cipher);

%Perform LSB substitution
[ex_cipher original_audio watermarked_audio mse psnr]=LSBsubstitution(t);

% % %Decryption
for j= 1:x
   message(j)=crypt(ex_cipher(j),N,d); 
end
disp('Decrypted ASCII of Message:');
disp(message);
disp(['Decrypted Message is: ' message]);

wavwrite(watermarked_audio,'airtel_watermarked');

% Display Performance parameters
disp(['MSE:',num2str(mse)]);
disp(['PSNR:',num2str(psnr)]);
toc;
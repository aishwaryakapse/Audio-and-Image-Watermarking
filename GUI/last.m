function varargout = last(varargin)
% LAST M-file for last.fig
%      LAST, by itself, creates a new LAST or raises the existing
%      singleton*.
%
%      H = LAST returns the handle to a new LAST or the handle to
%      the existing singleton*.
%
%      LAST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAST.M with the given input arguments.
%
%      LAST('Property','Value',...) creates a new LAST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before last_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to last_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help last

% Last Modified by GUIDE v2.5 13-Apr-2014 15:50:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @last_OpeningFcn, ...
                   'gui_OutputFcn',  @last_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before last is made visible.
function last_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to last (see VARARGIN)

% Choose default command line output for last
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes last wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = last_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname pathname ]=uigetfile('*.wav'); %select audio
original_audio=wavread([ pathname  fname]);
wavwrite(original_audio,'afile')
% sound(original_audio);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y=wavread('afile.wav')
sound(y);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(handles.edit1,'String');
% a=char(a);
fid=fopen('out.txt','wb');
fwrite(fid,char(a),'char');
fclose(fid);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = 67 ;
q = 97 ;
% disp('Intializing:');
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
%  disp(['The value of (p) is: ' num2str(p)]);
%  disp(['The value of (q) is: ' num2str(q)]);
% disp(['The value of (N) is: ' num2str(N)]);
% disp(['The public key (e) is: ' num2str(e)]);
% disp(['The value of (Phi) is: ' num2str(Phi)]);
% disp(['The private key (d)is: ' num2str(d)]);


% M = input('\nEnter the message: ','s');
fid=fopen('out.txt','r');
data=fread(fid);
M=char(data);
x=length(M);
c=0;
for j= 1:x
    for i=0:122
        if strcmp(M(j),char(i))
            c(j)=i;
        end
    end
end
% disp('ASCII Code of the entered Message:');
% disp(c); 

% % %Encryption
for j= 1:x
   cipher(j)=crypt(c(j),N,e); 
end
% disp('Cipher Text of the entered Message:');
disp(cipher);
t=de2bi(cipher);

[ex_cipher original_audio watermarked_audio mse psnr]=LSBsubstitution(t);
wavwrite(watermarked_audio,'audio_watermarked');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = 67 ;
q = 97 ;
% disp('Intializing:');
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
%  disp(['The value of (p) is: ' num2str(p)]);
%  disp(['The value of (q) is: ' num2str(q)]);
% disp(['The value of (N) is: ' num2str(N)]);
% disp(['The public key (e) is: ' num2str(e)]);
% disp(['The value of (Phi) is: ' num2str(Phi)]);
% disp(['The private key (d)is: ' num2str(d)]);


% M = input('\nEnter the message: ','s');
fid=fopen('out.txt','r');
data=fread(fid);
M=char(data);
x=length(M);
c=0;
for j= 1:x
    for i=0:122
        if strcmp(M(j),char(i))
            c(j)=i;
        end
    end
end
% disp('ASCII Code of the entered Message:');
% disp(c); 

% % %Encryption
for j= 1:x
   cipher(j)=crypt(c(j),N,e); 
end
% disp('Cipher Text of the entered Message:');
% disp(cipher);
t=de2bi(cipher);

[ex_cipher original_audio watermarked_audio mse psnr]=LSBsubstitution(t);

% %Decryption  c
for j= 1:x
   message(j)=crypt(ex_cipher(j),N,d); 
end
% disp('Decrypted ASCII of Message:');
disp(message);
a=char(message);
set(handles.edit2,'String',a);

disp(['Decrypted Message is: ' message]);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = 67 ;
q = 97 ;
% disp('Intializing:');
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
%  disp(['The value of (p) is: ' num2str(p)]);
%  disp(['The value of (q) is: ' num2str(q)]);
% disp(['The value of (N) is: ' num2str(N)]);
% disp(['The public key (e) is: ' num2str(e)]);
% disp(['The value of (Phi) is: ' num2str(Phi)]);
% disp(['The private key (d)is: ' num2str(d)]);


% M = input('\nEnter the message: ','s');
fid=fopen('out.txt','r');
data=fread(fid);
M=char(data);
x=length(M);
c=0;
for j= 1:x
    for i=0:122
        if strcmp(M(j),char(i))
            c(j)=i;
        end
    end
end
% disp('ASCII Code of the entered Message:');
% disp(c); 

% % %Encryption
for j= 1:x
   cipher(j)=crypt(c(j),N,e); 
end
% disp('Cipher Text of the entered Message:');
% disp(cipher);
t=de2bi(cipher);

[ex_cipher original_audio watermarked_audio mse psnr]=LSBsubstitution(t);
ms=num2str(mse);
set(handles.edit3,'String',ms);




function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = 67 ;
q = 97 ;
% disp('Intializing:');
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
%  disp(['The value of (p) is: ' num2str(p)]);
%  disp(['The value of (q) is: ' num2str(q)]);
% disp(['The value of (N) is: ' num2str(N)]);
% disp(['The public key (e) is: ' num2str(e)]);
% disp(['The value of (Phi) is: ' num2str(Phi)]);
% disp(['The private key (d)is: ' num2str(d)]);


% M = input('\nEnter the message: ','s');
fid=fopen('out.txt','r');
data=fread(fid);
M=char(data);
x=length(M);
c=0;
for j= 1:x
    for i=0:122
        if strcmp(M(j),char(i))
            c(j)=i;
        end
    end
end
% disp('ASCII Code of the entered Message:');
% disp(c); 

% % %Encryption
for j= 1:x
   cipher(j)=crypt(c(j),N,e); 
end
% disp('Cipher Text of the entered Message:');
% disp(cipher);
t=de2bi(cipher);

[ex_cipher original_audio watermarked_audio mse psnr]=LSBsubstitution(t);
ps=num2str(psnr);
set(handles.edit4,'String',ps);



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=wavread('audio_watermarked.wav')
sound(y1);

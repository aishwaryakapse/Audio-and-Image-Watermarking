function varargout = COLORDCT(varargin)
% COLORDCT M-file for COLORDCT.fig
%      COLORDCT, by itself, creates a new COLORDCT or raises the existing
%      singleton*.
%
%      H = COLORDCT returns the handle to a new COLORDCT or the handle to
%      the existing singleton*.
%
%      COLORDCT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLORDCT.M with the given input arguments.
%
%      COLORDCT('Property','Value',...) creates a new COLORDCT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before COLORDCT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to COLORDCT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help COLORDCT

% Last Modified by GUIDE v2.5 11-Mar-2014 13:35:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @COLORDCT_OpeningFcn, ...
                   'gui_OutputFcn',  @COLORDCT_OutputFcn, ...
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


% --- Executes just before COLORDCT is made visible.
function COLORDCT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to COLORDCT (see VARARGIN)

% Choose default command line output for COLORDCT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes COLORDCT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = COLORDCT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes6);
[fname pthname]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Asset Image'); %select image
I=imread([pthname fname]);
I=imresize(I,[512 512]);
imwrite(I,'originalimage.jpg');
imshow('originalimage.jpg');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes7);
[fname pthname]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Asset Image'); %select image
A=imread([pthname fname]);
imwrite(A,'watermarkimage.jpg');
imshow('watermarkimage.jpg');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
alpha=0.01; 
% [fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Original Image');
% originalImage=imread([pthname_o fname_o]);
originalImage=imread('originalimage.jpg');
watermarkedImage=zeros(512,512);
I=imresize(originalImage,[512 512]);
inputImage= im2double(I);
[R C f]=size(inputImage);
% subplot(2,2,1);
% imshow(inputImage);
% title('BASE IMAGE');

watermark=imread('watermarkimage.jpg'); 
[R1 C1 f1]=size(watermark);
watermarkImage=im2double(watermark);
% % subplot(2,2,2);
% imshow(watermark);
% title('WATERMARK IMAGE');
k1=ceil((R1*C1)/(64*64));

for x=1:3
    w=single(watermarkImage(:,:,x),R1,C1);
    Y=length(w);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=inputImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=single(f,8,8);
            for k=1:k1
                if count<=Y
                    f1(1,k+10)=w(1,count)*alpha;
                    count=count+1;
                end
            end
            out1=pras(f1,8,8);
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
axes(handles.axes3);
imshow(res);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%IMAGE WATERMARKING USING DCT

alpha=0.01; 
% [fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Original Image');
% originalImage=imread([pthname_o fname_o]);
originalImage=imread('originalimage.jpg');
watermarkedImage=zeros(512,512);
I=imresize(originalImage,[512 512]);
inputImage= im2double(I);
[R C f]=size(inputImage);
% imshow(inputImage);
% title('BASE IMAGE');

watermark=imread('watermarkimage.jpg'); 
[R1 C1 f1]=size(watermark);
watermarkImage=im2double(watermark);
% subplot(2,2,2);
% imshow(watermark);
% title('WATERMARK IMAGE');
k1=ceil((R1*C1)/(64*64));

for x=1:3
    w=single(watermarkImage(:,:,x),R1,C1);
    Y=length(w);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=inputImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=single(f,8,8);
            for k=1:k1
                if count<=Y
                    f1(1,k+10)=w(1,count)*alpha;
                    count=count+1;
                end
            end
            out1=pras(f1,8,8);
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
% subplot(2,2,3);
% imshow(res);
% title('IMAGE AFTER WATERMARKING');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %WATERMARK EXTRACTION
for x=1:3
    W1=zeros(R1,C1);
    w=single(W1,R1,C1);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=watermarkedImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=single(f,8,8);
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
     op(:,:,x)=im2uint8(pras(w,R1,C1));
end
% subplot(2,2,4);
% imshow(op);
% title('Extracted Watermark Image');
axes(handles.axes4);
imshow(op);
% title('Extracted watermark');



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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
alpha=0.01; 
% [fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Original Image');
% originalImage=imread([pthname_o fname_o]);
originalImage=imread('originalimage.jpg');
watermarkedImage=zeros(512,512);
I=imresize(originalImage,[512 512]);
inputImage= im2double(I);
[R C f]=size(inputImage);
% subplot(2,2,1);
% imshow(inputImage);
% title('BASE IMAGE');

watermark=imread('watermarkimage.jpg'); 
[R1 C1 f1]=size(watermark);
watermarkImage=im2double(watermark);
% subplot(2,2,2);
% imshow(watermark);
% title('WATERMARK IMAGE');
k1=ceil((R1*C1)/(64*64));

for x=1:3
    w=single(watermarkImage(:,:,x),R1,C1);
    Y=length(w);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=inputImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=single(f,8,8);
            for k=1:k1
                if count<=Y
                    f1(1,k+10)=w(1,count)*alpha;
                    count=count+1;
                end
            end
            out1=pras(f1,8,8);
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
% subplot(2,2,3);
% imshow(res);
% title('IMAGE AFTER WATERMARKING');
[mse psnr]=parameter(res,I);
a=num2str(mse);
set(handles.edit1,'String',a);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
alpha=0.01; 
% [fname_o pthname_o]=uigetfile('*.jpg;*.png;*.tif;*bmp','Select the Original Image');
% originalImage=imread([pthname_o fname_o]);
originalImage=imread('originalimage.jpg');
watermarkedImage=zeros(512,512);
I=imresize(originalImage,[512 512]);
inputImage= im2double(I);
[R C f]=size(inputImage);
% subplot(2,2,1);
% imshow(inputImage);
% title('BASE IMAGE');

watermark=imread('watermarkimage.jpg'); 
[R1 C1 f1]=size(watermark);
watermarkImage=im2double(watermark);
% subplot(2,2,2);
% imshow(watermark);
% title('WATERMARK IMAGE');
k1=ceil((R1*C1)/(64*64));

for x=1:3
    w=single(watermarkImage(:,:,x),R1,C1);
    Y=length(w);
    r1=1;r2=8;
    c1=1;c2=8;
    count=1;
    for i=1:64
        for j=1:64
            block=inputImage(r1:r2,c1:c2,x);
            f=dct2(block);
            f1=single(f,8,8);
            for k=1:k1
                if count<=Y
                    f1(1,k+10)=w(1,count)*alpha;
                    count=count+1;
                end
            end
            out1=pras(f1,8,8);
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
% subplot(2,2,3);
% imshow(res);
% title('IMAGE AFTER WATERMARKING');
[mse psnr]=parameter(res,I);
b=num2str(psnr);
set(handles.edit2,'String',b);

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

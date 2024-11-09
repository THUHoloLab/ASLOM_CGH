clc;
tic;
clear all;
Lamda=532.0e-6; 
dL=8.0e-3;
k=2*pi/Lamda;

DEPTH = imread('toy_d.bmp');
DEPTH=imresize(DEPTH,[1080,1920]); 
% DEPTH = im2double(DEPTH);
DEPTH = rgb2gray(DEPTH); 
POSITION = imread('toy_s.bmp'); 
POSITION=imresize(POSITION,[1080,1920]);
% POSITION = im2double(POSITION);
POSITION = rgb2gray(POSITION); 


[N,M]=size(POSITION);
[fx,fy]=meshgrid(linspace(-1/(2*dL),1/(2*dL),M),linspace(-1/(2*dL),1/(2*dL),N));
AnDiffract=0;
n = 3;  
STEP = 256/n;  

OUTPUT = zeros(N,M,n);
 for I = 1:n
     [x,y]=find(DEPTH>(I-1)*STEP & DEPTH<=I*STEP);
     for J=1:length(x);
         OUTPUT(x(J),y(J),I)=POSITION(x(J),y(J));
     end     
    A=OUTPUT(:,:,I);
    A=im2double(A);
    oz=160+20*(n-I)/n;
    A1=A.*exp(1i*2*pi*rand(N,M));
    HFunct=exp(1i*k*oz.*sqrt(1-(Lamda*fx).^2-(Lamda*fy).^2)); 
    DScreen_F=fftshift(fft2(fftshift(A1))); 
    AnDiffract=fftshift(ifft2(fftshift(DScreen_F.*HFunct)))+AnDiffract;
 end
An=mat2gray(angle(AnDiffract));
imwrite(An,'toy_CGH.bmp');
Anf=fftshift(fft2(fftshift(AnDiffract)));
Anfg=mat2gray(angle(Anf));
%imwrite(Anfg,'hall_hf_50.bmp');
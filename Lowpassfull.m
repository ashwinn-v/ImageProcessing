clc;
clear;
close all;
ko=im2double(imread('lennacol.png')); % convert int double

ko = imresize(ko,[256,256]);
im = imnoise(ko,'Gaussian');

%{
p = .1; % p between 0 and 1
im = (ko + p*rand(size(ko)))/(1+p);
%}

%% 
figure(1)
subplot(3,3,1);
imshow(im);
title('original image');

fftImage=fft2(im);

Y = fftshift(fftImage);
subplot(3,3,2);
imshow(real(log(Y)), []);
title('In Frequency Domain');

[rows, columns, ~] = size(Y)
%[rows, columns] = size(Y)
L=Y;
%%
 % Applying the kernels on the image.

%% 
B=idealLPFilter(L,rows,columns);
C=gaussianLPFilter(L,rows,columns);
D=butterworthLPFilter(L,rows,columns);
%% 

subplot(3,3,3);
imshow(real(log(B)), [])
title('Ideal Low Pass Filter(Frequency Domain)');


subplot(3,3,4);
imshow(log(abs(C)),[]);
title('Gaussian Low Pass Filter(Frequency Domain)');

subplot(3,3,5);
imshow(log(abs(D)), []);
title('Butterworth Low Pass Filter(Frequency Domain)');
%% 
% Applying inverse fft on the filtered images

%%
filteredImage = real(ifft2(ifftshift(B)));
subplot(3,3,6);
imshow(real(filteredImage), []);
title('Output: Ideal Low Pass Filter');


GfilteredImage = real(ifft2(ifftshift(C)));
subplot(3,3,7);
imshow(real(GfilteredImage), []);
title('Output: Gaussain Low Pass Filter');

BfilteredImage = real(ifft2(ifftshift(D)));
subplot(3,3,8);
imshow(real(BfilteredImage), []);
title('Output: Butterworth Low Pass Filter');
%% 
% Greater the accuracy less will be the mean-squared error

%% 
err = immse(real(filteredImage), ko);
fprintf('\n The mean-squared error is of ideal filtered image %0.4f\n', err);

err = immse(real(GfilteredImage), ko);
fprintf('\n The mean-squared error is Gaussian filtered image is %0.4f\n', err);

err = immse(real(BfilteredImage), ko);
fprintf('\n The mean-squared error of Butterworth filter treated image is %0.4f\n', err);
%% 
% The more different less will be the SSIM

%% 
err = ssim(real(filteredImage), ko);
fprintf('\n The Structural similarity (SSIM) index of ideal filtered image %0.4f\n', err);
[ssimval,ssimmap] = ssim(real(filteredImage), ko);
figure(2)
subplot(1,3,1);
imshow(ssimmap,[])
title(['Local SSIM Map with Global SSIM Value: ',num2str(ssimval)])

err = ssim(real(GfilteredImage), ko);
fprintf('\n The Structural similarity (SSIM) index of Gaussian filtered image is %0.4f\n', err);
[ssimval,ssimmap] = ssim(real(GfilteredImage), ko);
subplot(1,3,2);
imshow(ssimmap,[])
title(['Local SSIM Map with Global SSIM Value: ',num2str(ssimval)])

err = ssim(real(BfilteredImage), ko);
fprintf('\n Structural similarity (SSIM) index of Butterworth filter treated image is %0.4f\n', err);
[ssimval,ssimmap] = ssim(real(BfilteredImage), ko);
subplot(1,3,3);
imshow(ssimmap,[])
title(['Local SSIM Map with Global SSIM Value: ',num2str(ssimval)])
%% 
% The higher the PSNR, the better the quality of the compressed, or reconstructed image.

%% 
[peaksnr, snr] = psnr(filteredImage, ko);
fprintf('\n The Peak-SNR value of ideal filteredImage is %0.4f',peaksnr);
fprintf('\n\n The SNR value of ideal filteredImage is %0.4f \n\n', snr);

[peaksnr, snr] = psnr(GfilteredImage, ko);
fprintf('\n The Peak-SNR value of Gaussian filteredImage is %0.4f',peaksnr);
fprintf('\n\n The SNR value of Gaussian filteredImage is %0.4f \n\n', snr);

[peaksnr, snr] = psnr(BfilteredImage, ko);
fprintf('\n The Peak-SNR value of Butterworth filteredImage is %0.4f',peaksnr);
fprintf('\n\n The SNR value of Butterworth filteredImage is %0.4f \n\n', snr);
%%
% Analysis using edge detection

%%
ko1 = rgb2gray(ko);
O1 = edge(ko1,'sobel');
O2 = edge(ko1,'canny');
figure(3);
subplot(3,2,1);
imshow(O1);
title('edges on original image using sobel');
subplot(3,2,2);
imshow(O2);
title('edges on original image using canny');

im2 = rgb2gray(im);
O1 = edge(im2,'sobel');
O2 = edge(im2,'canny');
figure(3);
subplot(3,2,3);
imshow(O1);
title('edges on noisy image using sobel');
subplot(3,2,4);
imshow(O2);
title('edges on noisy image using canny');

FIM = rgb2gray(real(GfilteredImage));
O1 = edge(im2,'sobel');
O2 = edge(im2,'canny');
figure(3);
subplot(3,2,5);
imshow(O1);
title('edges on filtered image using sobel');
subplot(3,2,6);
imshow(O2);
title('edges on filtered image using canny');




%% 
% Fuction definition of the filters

%% 
function B = idealLPFilter(L,rows,columns)
    window = 100;
    B=L;
    B(1:end, 1:window) = 0;%top left
    B(1:window,1:end) = 0; %bottom left
    B(1:end, end-window:end) = 0; %top right
    B(end-window:end, 1:end) = 0;%bottom right
    
end

function C = gaussianLPFilter(L,rows,columns)
    R=20; %Filter size parameter
    X=0:columns-1;
    Y=0:rows-1;
    [X Y]=meshgrid(X,Y);

    Cx=0.5*columns;
    Cy=0.5*rows;

    Hi = exp(-((X-Cx).^2+(Y-Cy).^2)./(2*R).^2);
    C=L.*Hi;
end

function D = butterworthLPFilter(L,rows,columns)
    n=1;
    D0=20;
    [p q]=meshgrid(-floor(columns/2):floor(columns/2)-1,-floor(rows/2):floor(rows/2)-1);
    D = sqrt(p.^2 + q.^2);
    hhp = 1 ./ (1 + ((D ./ D0).^(2 * n)));
    size(L)
    size(hhp)
    D=L.*hhp;
end
%% 





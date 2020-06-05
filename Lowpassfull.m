clc;
clear;
close all;
ko=im2double(imread('colorimg.jpeg')); % convert int double

ko = imresize(ko,[256,256]);
im = imnoise(ko,'gaussian',.05);

%{
p = .1; % p between 0 and 1
im = (ko + p*rand(size(ko)))/(1+p);
%}


subplot(3,3,1);
imshow(im);
title('original image');

fftImage=fft2(im);

Y = fftshift(fftImage);
subplot(3,3,2);
imshow(real(log(Y)), []);
title('In Frequency Domain');

[rows, columns, ~] = size(Y)
L=Y;
B=idealLPFilter(L,rows,columns);
C=gaussianLPFilter(L,rows,columns);
D=butterworthLPFilter(L,rows,columns);


subplot(3,3,3);
imshow(real(log(B)), [])
title('Ideal Low Pass Filter(Frequency Domain)');


subplot(3,3,4);
imshow(log(abs(C)),[]);
title('Gaussian Low Pass Filter(Frequency Domain)');

subplot(3,3,5);
imshow(log(abs(D)), []);
title('Butterworth Low Pass Filter(Frequency Domain)');


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


err = immse(real(filteredImage), ko);
fprintf('\n The mean-squared error is of ideal filtered image %0.4f\n', err);

err = immse(real(GfilteredImage), ko);
fprintf('\n The mean-squared error is Gaussian filtered image is %0.4f\n', err);

err = immse(real(BfilteredImage), ko);
fprintf('\n The mean-squared error of Butterworth filter treated image is %0.4f\n', err);



function B = idealLPFilter(L,rows,columns)
    window = 100;
    B=L;
    B(1:end, 1:window) = 0;%top left
    B(1:window,1:end) = 0;
    B(1:end, end-window:end) = 0; %top right
    B(end-window:end, 1:end) = 0;%down right
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


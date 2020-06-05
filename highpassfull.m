clc;
clear;
close all;
im=im2double(imread('cameraman.tif'));



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
B=idealHPFilter(L,rows,columns);
C=gaussianHPFilter(L,rows,columns);
D=butterworthHPFilter(L,rows,columns);

subplot(3,3,3);
imshow(real(log(B)), [])
title('Ideal High Pass Filter(Frequency Domain)');

subplot(3,3,4);
imshow(log(abs(C)),[]);
title('Gaussian High Pass Filter(Frequency Domain)');

subplot(3,3,5);
imshow(log(abs(D)), []);
title('Butterworth High Pass Filter(Frequency Domain)');

filteredImage = real(ifft2(ifftshift(B)));
subplot(3,3,6);
imshow(real(filteredImage), []);
title('Output: Ideal High Pass Filter');


GfilteredImage = real(ifft2(ifftshift(C)));
subplot(3,3,7);
imshow(real(GfilteredImage), []);
title('Output: Gaussain High Pass Filter');

BfilteredImage = real(ifft2(ifftshift(D)));
subplot(3,3,8);
imshow(real(BfilteredImage), []);
title('Output: Butterworth High Pass Filter');


function B = idealHPFilter(L,rows,columns)
    centerX = round(columns / 2)
    centerY = round(rows / 2)
    % Filter: Erase center spike.
    filterWidth = 15;
    B=L;
    B(centerY-filterWidth:centerY+filterWidth, centerX-filterWidth : centerX+filterWidth) = 0 ;
   
end

function C = gaussianHPFilter(L,rows,columns)
    R=60; %Filter size parameter
    X=0:columns-1;
    Y=0:rows-1;
    [X Y]=meshgrid(X,Y);

    Cx=0.5*columns;
    Cy=0.5*rows;

    Hi = 1- exp(-((X-Cx).^2+(Y-Cy).^2)./(2*R).^2);
    C=L.*Hi;
end

function D = butterworthHPFilter(L,rows,columns)
    n=1;
    D0=50;
    [p q]=meshgrid(-floor(columns/2):floor(columns/2)-1,-floor(rows/2):floor(rows/2)-1);
    D = sqrt(p.^2 + q.^2);
    hhp = 1 ./ (1 + ((D0 ./ D).^(2 * n)));
    D=L.*hhp;
end
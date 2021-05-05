# Image Enhancement using Fourier transforms

Images are used in various fields to help monitoring processes such as images in fingerprint evaluation, satellite monitoring, medical diagnostics, underwater areas, etc. Image processing techniques is adopted as an optimised method to help the processing tasks efficiently. Fourier transform is one such important image processing method that can transform the image from spatial domain to frequency domain. In this paper, we apply a number of frequency domain filters for reducing the noise as well as to detect the edges. The quality of reconstructed image is analysed by calculating different parameters like mean squared error and peak signal noise ratio. The results are tabulated, and the best filter for a particular application is thereby determined.


###  THE ONE DIMENSIONAL DISCRETE FOURIER TRANSFORM
Discrete Fourier transform (DFT) converts a finite sequence of equally-spaced samples of a function into a same-length sequence of equally-spaced samples of the discrete-time Fourier transform (DTFT), which is a complex-valued function of frequency. The interval at which the DTFT is sampled is the reciprocal of the duration of the input sequence.
For a sequence of length N,

In two dimensions [1], the DFT takes a matrix as input, and returns another matrix, of the same size, as output. If the original matrix values are , where and are the indices, then the output matrix values are . We call the matrix F, the Fourier transform of the matrix f. The original matrix is the inverse Fourier transform of F.

The definition of the two-dimensional discrete Fourier transform strikes a resemblance to that for one dimension.
The forward and inverse transforms for an matrix, where for notational convenience we assume that the x indices are from 0 to M-1 and the y indices are from 0 to N-1, are:
<p align="center">
<img width="342" alt="Screenshot 2021-05-06 at 2 28 59 AM" src="https://user-images.githubusercontent.com/52974732/117208497-d1f3eb00-ae12-11eb-9b74-5c3ab18b2a93.png">


###  TWO DIMENSIONAL DISCRETE FOURIER TRANSFORMS

<p align="center">
<img width="270" alt="Screenshot 2021-05-06 at 2 27 58 AM" src="https://user-images.githubusercontent.com/52974732/117208372-ae30a500-ae12-11eb-96de-b159fcebb333.png">
 </p>



The following code can be use for image noise reduction and edge filtering using fft function in matlab.
Noise reduction can be done using a low pass filter and edge detection can be done using a high pass filter.

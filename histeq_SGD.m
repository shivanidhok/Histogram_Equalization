function [I_eq] = histeq_SGD(str)
%% Function Description
% Author: Shivani Dhok
% Date of Creation: January 3, 2019
% Digital Image Processing
% Function for: Histogram equalization

% The function 'histeq_SGD()' performs histogram equalization of an image.
% 
% Input:
% str = String that contains path for image whose histogram equalization is 
%       to be done.
% Output:
% I_eq = Histogram Equalized image.
% 
% The function returns the histogram equalized image (I_eq) in the unsigned 
% integer 8 bit (uint8).
%% Reading an image...
I = imread(str);
%% Converting to gray...
[a b c] = size(I);
if c == 3
    I_gray = rgb2gray(I);
end
% Since the format of the image is considered to have 8 bit format, i.e.,
% uint8, the value of L, i.e., levels, is taken as 2^8 = 256.
L = 256;                        
%% Processing...
[row col] = size(I_gray);                       % Size of gray image
len = row * col;                                % Total number of pixels
I_vec = I_gray(:);                              % Vectorinzing the matrix
I_sort = sort(I_vec);                           % Sorting the values in ascending values
I_unq = unique(I_sort);                         % Finding unique values
I_count = zeros(length(I_unq),1);               % Generate a zero matrix of dimensions as I_sort 
%% Counting the frequency of the unique values...
jj = 1;             
for ii = 1:length(I_unq)
    while(jj <= len & I_unq(ii) == I_sort(jj))
        I_count(ii) = I_count(ii)+1;
        jj = jj+1;
    end
end
%% Generating the cumulative distribution function (CDF)
CDF = cumsum(I_count);
cdf_min = min(CDF);                                     % Min CDF
H_eq = round((CDF-cdf_min)./(len-cdf_min).*(L-2))+1;    % Equalized intensity value
%% Placing the values of new intensities to proper location...
I_eq = zeros(row,col);
for jj = 1:length(I_unq)
    I_eq(I_gray == I_unq(jj)) = H_eq(jj);
end
%% Equalized image converted to uint8
I_eq = uint8(I_eq);
      

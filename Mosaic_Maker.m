% Clear workspace, command window, and close all figures
clear; clc; close all;

% Define the dataset folder and pattern for image files
Dataset_folder = 'Dataset\*.jpg';

% Check if the dataset folder exists; if not, unzip the example dataset
if isfolder('Dataset') == 0
    unzip('Dataset.zip');
end

% Set parameters for mosaic creation
S = 60;               % Size of the mosaics
N = 60;               % Number of images per side
TargetImage = 'a3.jpg';
remake_dataset = 1;   % Option to remake the dataset

% Create or load the dataset
if remake_dataset
    % If remaking the dataset, read images, preprocess, and save information
    D = dir(Dataset_folder);
    for I = 1:size(D, 1)
        disp(['reading image ' num2str(I)])
        A = imread([D(I).folder '/' D(I).name]);
        
        % Preprocess image to make it square and remove borders
        L = max([size(A, 1), size(A, 2)]);
        W = min([size(A, 1), size(A, 2)]);
        d = ceil(abs(size(A, 1) - size(A, 2)) / 2);
        if size(A, 1) > size(A, 2)
            A = A(d+1:end-d, :, :);
        end
        if size(A, 1) < size(A, 2)
            A = A(:, d+1:end-d, :);
        end
        marg = ceil(size(A, 1) * 0.05);
        A = A(marg+1:end-marg, marg+1:end-marg, :);
        A = imresize(A, [S, S]);
        
        % Store preprocessed image and its color information
        M(I).A = A; 
        V(I, :) = [mean(mean(A(:, :, 1))), mean(mean(A(:, :, 2))), mean(mean(A(:, :, 3)))];
    end
    % Save the dataset information
    save('M', 'M'); save('V', 'V');
else
    % If not remaking the dataset, load precomputed dataset information
    load('M.mat'); load('V.mat');
end

% Load the target image for mosaic creation
A = imread(TargetImage);
A0 = A;

% Preprocess target image to make it square and remove borders
L = max([size(A, 1), size(A, 2)]);
W = min([size(A, 1), size(A, 2)]);
d = ceil(abs(size(A, 1) - size(A, 2)) / 2);
if size(A, 1) > size(A, 2)
    A = A(d+1:end-d, :, :);
end
if size(A, 1) < size(A, 2)
    A = A(:, d+1:end-d, :);
end
A = imresize(A, [N, N]);
R = A;

% Load precomputed dataset information
load('M.mat'); load('V.mat');
V = double(V);
B = uint8(zeros(N*S, N*S, 3));
R = imresize(R, [N, N]);
A2 = imresize(A0, [N*S, N*S]);

% Create the mosaic by replacing each block in the target image with the
% closest matching block from the dataset
for I = 1:N
    for J = 1:N
        v = double([R(I, J, 1), R(I, J, 2), R(I, J, 3)]);
        v = repmat(v, size(V, 1), 1);
        [o, p] = min(mean(abs(V - v), 2));
        t = M(p).A;
        Rat = v(1, :) ./ V(p, :);
        t(:, :, 1) = t(:, :, 1) .* Rat(1); 
        t(:, :, 2) = t(:, :, 2) .* Rat(2); 
        t(:, :, 3) = t(:, :, 3) .* Rat(3);
        B(I*S-S+1:I*S, J*S-S+1:J*S, :) = t;   
    end
end

% Blend the mosaic with the original target image using a weight parameter
w = 0.05;
B = uint8((double(B) .* (1 - w) + double(A2) .* w));

% Save the final mosaic image and display it
imwrite(B, ['Mosaic_' TargetImage]);
figure;
imshow(B);

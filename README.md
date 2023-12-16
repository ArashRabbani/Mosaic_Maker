# Mosaic_Maker
Quickly generates a mosaic image from a folder with plenty of images


This simple Matlab code quickly generates mosaic images using a folder containing a good number of images. The current dataset comprises 620 robot portrait images, made via stable-diffusion-v1-4 pretrained model. Images are stored in the 'Dataset' folder which is zipped.

## Examples

### Original Image: a1.jpg
![Original Image](a1.jpg)

### Mosaic Image: Mosaic_a1.jpg
![Mosaic Image](Mosaic_a1.jpg)

### Original Image: a3.jpg
![Original Image](a3.jpg)

### Mosaic Image: Mosaic_a3.jpg
![Mosaic Image](Mosaic_a3.jpg)

## Dataset
The dataset comprises 620 robot portrait images, meticulously crafted using the stable-diffusion-v1-4 pretrained model. Images are stored in the 'Dataset' folder.

## Usage
1. Ensure the dataset is available in the 'Dataset' folder. If not, put at least 100 images there.

2. Adjust parameters in the code, such as mosaic size (\`S\`), number of images per side (\`N\`), target image file (\`TargetImage\`), and dataset regeneration flag (\`remake_dataset\`).

3. Run the MATLAB script to generate mosaic images.

```matlab
% Set parameters for mosaic creation
S = 60;               % Size of the mosaics
N = 60;               % Number of images per side
TargetImage = 'a3.jpg';
remake_dataset = 0;   % Option to remake the dataset
```

### Installation

```bash
git clone https://github.com/ArashRabbani/Mosaic_Maker.git
cd mosaic_maker
```
### Enjoy! :D



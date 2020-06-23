clear, close all, clc;
Rock_BW_Image=imread('canvas_4_v01_ccitt.tif');
for Decrease_factor=0.4:-0.05:0.05
    Crop_BW_Image = imcrop(Rock_BW_Image,[1 1 size(Rock_BW_Image,2) - 2500 size(Rock_BW_Image,1) - 1500]);
    Crop_BW_Image  = imerode(Crop_BW_Image ,strel('disk', 3, 0));
    Crop_BW_Image = imresize(Crop_BW_Image,Decrease_factor,'nearest');
    Crop_BW_Image=Crop_BW_Image';
    mindensity=1;
    maxdensity=0;
    for i=1:20:size(Crop_BW_Image,1)-420
        for j=1:20:size(Crop_BW_Image,2)-560
            cropped_image=Crop_BW_Image(i:i+420-1,j:j+560-1);
            tempdensity=(sum(sum(~cropped_image)))/(420*560);
            if tempdensity<mindensity
                mindensity=tempdensity;
                lowdenseimage=cropped_image;
            end
            if tempdensity>maxdensity
                maxdensity=tempdensity;
                highdenseimage=cropped_image;
            end
        end
    end
    filename = strcat('Vert_HighDenseStylos',num2str(Decrease_factor),'density',num2str(round(maxdensity*100)),'%.tiff');
    imwrite(highdenseimage,filename);
    filename = strcat('Vert_LowDenseStylos',num2str(Decrease_factor),'density',num2str(round(mindensity*100)),'%.tiff');
    imwrite(lowdenseimage,filename);
end
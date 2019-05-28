clear, close all;
Rock_BW_Image = imread('canvas_4_v01_ccitt.tif');%'StyloCut.png'
Rock_BW_Image = imcrop(Rock_BW_Image,[1 1 size(Rock_BW_Image,2) - 2500 size(Rock_BW_Image,1) - 1500]);
Rock_BW_Image  = imerode(Rock_BW_Image ,strel('disk', 5, 0));
XSize = 560;
YSize = 420;
x = XSize*5;
y = YSize*2;
Rock_BW_Image   = imresize(Rock_BW_Image,[y x]);

Xi = 1;
Yi = 1;

while (Xi + XSize-1 <= x)
    while (Yi + YSize-1 <= y)
        s = imcrop(Rock_BW_Image,[Xi Yi XSize-1 YSize-1]); %horizontal stylolites [xmin ymin width height]
        StyloPercent = length(s(s==0))/(YSize*XSize);
        filename = strcat('Stylos\2',num2str(round(StyloPercent*10000)),'%.tif');
        imwrite(s,filename);
        Yi = Yi + YSize;
    end
    Yi = 1;
    Xi = Xi + XSize;
end
Crop_BW_Image=imread('session2_from_Simon_Cut.png');
Crop_BW_Image=rgb2gray(Crop_BW_Image);
Crop_BW_Image=imbinarize(Crop_BW_Image);
%Crop_BW_Image  = imerode(Crop_BW_Image ,strel('disk', 3, 0));
%Crop_BW_Image = imresize(Crop_BW_Image,0.2,'nearest');

%Crop_BW_Image = imcrop(Rock_BW_Image,[1 1 size(Rock_BW_Image,2) - 2500 size(Rock_BW_Image,1) - 1500]);

%% Choose Scale
%low dense
   Scale = 1; Disk = 3;
%mid dense
   % Scale = 2.2; Disk = 2;
%high dense
   %Scale = 3.3; Disk = 3;
%very high dense
    %Scale = 4.4; Disk = 4;

height = 419*Scale;
width = 559*Scale;
c = 'r';
%% Choose Vertical Or Horizontal
Orientation = 'Horizontal';%Orientation = 'Vertical';
if (strcmp(Orientation,'Vertical'))
    t = height;
    height = width;
    width = t;
    c = 't';
end
%% Running through Raw Image

for i = 1:100:(size(Crop_BW_Image,1)-height)
    for j = 1:100:(size(Crop_BW_Image,2) - width)
        % Cropping and And Fixing Styloline width
        m = imresize(imerode(Crop_BW_Image(i:(height+i),j:(width+j)),strel('disk', Disk, 0)),1/Scale);
        if (strcmp(Orientation,'Vertical'))
            m = m';
        end
        
        % Calculating StyloDensity
        Whites = sum(sum(m));
        Blacks = sum(sum(m==0));
        StyloDensity = Blacks/Whites*100;
        
        % saving only conditioned Densitys
        if(StyloDensity >.013)
            filename = strcat(c,num2str(StyloDensity),'%.tiff');
            imwrite(m,filename);
        end
    end
end
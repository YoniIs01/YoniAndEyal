Rock_BW_Image=imread('canvas_4_v01_ccitt.tif');
Crop_BW_Image = imcrop(Rock_BW_Image,[1 1 size(Rock_BW_Image,2) - 2500 size(Rock_BW_Image,1) - 1500]);

%% Choose Scale
%low dense
%       Scale = 1.3; Disk = 1;
%mid dense
%     Scale = 2.2; Disk = 2;
%high dense
     Scale = 3.3; Disk = 3;

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
for i = 1:200:(7553-height)
    for j = 1:500:(33669 - width)
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
        if(StyloDensity >= 15)
            C2 = normxcorr2(x,m);
            if max(C2(:)) > 0.5
                filename = strcat(c,num2str(StyloDensity),'%.tiff');
                imwrite(m,filename);
            end
        end
    end
end
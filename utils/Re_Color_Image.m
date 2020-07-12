function [Correct_color_RGB] = Re_Color_Image(orig_image)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Correct_color_RGB=uint8(orig_image);
for i=1:size(Correct_color_RGB,1)
    for j=1:size(Correct_color_RGB,2)
        if(Correct_color_RGB(i,j,1)==0 && Correct_color_RGB(i,j,2)==0 && Correct_color_RGB(i,j,3)==224)
            Correct_color_RGB(i,j,1)=255;
            Correct_color_RGB(i,j,2)=230;
            Correct_color_RGB(i,j,3)=153;
        else if(Correct_color_RGB(i,j,1)==133 && Correct_color_RGB(i,j,2)==0 && Correct_color_RGB(i,j,3)==0)
                Correct_color_RGB(i,j,1)=0;
                Correct_color_RGB(i,j,2)=0;
                Correct_color_RGB(i,j,3)=0;
            end
        end
    end
end
%figure;
%imshow(Correct_color_RGB,'Border','tight');
%set(gcf,'Position',[0 0 240*3 150*3]);

end


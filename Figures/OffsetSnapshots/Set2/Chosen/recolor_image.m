filename='0.5_Step381_Image.png';
open(filename);
for i=1:size(cdata,1)
    for j=1:size(cdata,2)
        if(cdata(i,j,1)==0 && cdata(i,j,2)==0 && cdata(i,j,3)==224)
            cdata(i,j,1)=255;
            cdata(i,j,2)=242;
            cdata(i,j,3)=204;
        else if(cdata(i,j,1)==133 && cdata(i,j,2)==0 && cdata(i,j,3)==0)
                cdata(i,j,1)=0;
                cdata(i,j,2)=0;
                cdata(i,j,3)=0;
            end
        end
    end
end
imshow(cdata,'Border','tight');
set(gcf,'Position',[0 0 240*3 150*3]);
saveas(gcf,[ 'recolor_' filename]);

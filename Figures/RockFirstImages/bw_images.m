function [cdata] = bw_images(filename)
cdata=imread(filename);
for i=1:size(cdata,1)
    for j=1:size(cdata,2)
        if(cdata(i,j,1)==0 && cdata(i,j,2)==0 && cdata(i,j,3)==224)
            cdata(i,j,1)=255;
            cdata(i,j,2)=255;
            cdata(i,j,3)=255;
        else if(cdata(i,j,1)==133 && cdata(i,j,2)==0 && cdata(i,j,3)==0)
                cdata(i,j,1)=0;
                cdata(i,j,2)=0;
                cdata(i,j,3)=0;
            end
        end
    end
end
cdata = imcrop(cdata,[0, 0, 420, 420]);
imshow(cdata,'Border','tight');
axis square;
%set(gcf,'Position',[0 0 240*3 150*3]);
saveas(gcf,[ 'bw_' filename]);

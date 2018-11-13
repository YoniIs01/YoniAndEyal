filename=strcat(num2str(length(Rock_Frames)),...
  'time steps');
images=cell(1,[]);
croppedim=cell(1,[]);
for i=1:length(Rock_Frames)
        images{i}=frame2im(Rock_Frames([i]));
        croppedim{i}=imcrop(images{i},[109 0 343 291]); 
        crop_frames_3200(i)=im2frame(croppedim{1,i});
end
v=VideoWriter(filename,'MPEG-4');
vObj.Quality = 100; 
open(v)
writeVideo(v,crop_frames_3200);
close(v)
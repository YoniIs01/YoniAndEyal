m = ModelData.LoadFromQuery('RockType=3;NumGrains=100',17);
disp(m.Orientation);
FirstImage = m.RockFirstImage(1:151,80:320);
i = [m.Steps.Mechanical_Dissolution] > 100;
Matrixes = m.GetRockMatrixesByStep();
Matrixes = Matrixes(i);
s = m.Steps(i);
FinalImage = Matrixes{7}(1:151,80:320);

%imshow(label2rgb(FirstImage),'Border','tight');
%set(gcf,'Position',[0 0 240*3 150*3]);
%saveas(gcf,[m.Orientation '_FirstImage.emf']);
imshow(label2rgb(FinalImage),'Border','tight');
set(gcf,'Position',[0 0 240*3 150*3]);
saveas(gcf,[m.Orientation '_Step_' num2str(s(7).StepId) '_Image.emf']);

m = ModelData.LoadFromQuery('RockType=1',1);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\Voronoi.png')
m = ModelData.LoadFromQuery('RockType=2',1);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\Table.png')
m = ModelData.LoadFromQuery('RockType=3',1);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\BrickWall.png')
m = ModelData.LoadFromQuery('RockType=4;Orientation=Vertical',50);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\StyloVertical.png')
m = ModelData.LoadFromQuery('RockType=4;Orientation=Horizontal',50);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\StyloHorizontal.png')
m = ModelData.LoadFromQuery('RockType=5',1);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\Hexagon.png')
m = ModelData.LoadFromQuery('RockType=6',2);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\Cracks.png')
m = ModelData.LoadFromQuery('RockType=7',5);
imwrite(label2rgb(m.RockFirstImage),'Figures\RockFirstImages\Cracks2.png')
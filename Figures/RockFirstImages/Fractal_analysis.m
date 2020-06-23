%% Computing a fractal dimension with Matlab: 1D, 2D and 3D Box-counting 
% F. Moisy, 9 july 2008.
% University Paris Sud.

%% About Fractals and box-counting
% A set (e.g. an image) is called "fractal" if it displays self-similarity:
% it can be split into parts, each of which is (at least approximately)
% a reduced-size copy of the whole.
%
% A possible characterisation of a fractal set is provided by the
% "box-counting" method: The number N of boxes of size R needed to cover a
% fractal set follows a power-law, N = N0 * R^(-DF), with DF<=D (D is the
% dimension of the space, usually D=1, 2, 3).
%
% DF is known as the Minkowski-Bouligand dimension, or Kolmogorov capacity,
% or Kolmogorov dimension, or simply box-counting dimension.
% 
% To learn more about box-counting, fractals and fractal dimensions:
%
% - http://en.wikipedia.org/wiki/Fractal 
%
% - http://en.wikipedia.org/wiki/Box_counting_dimension
%
% - http://mathworld.wolfram.com/Fractal.html
%
% - http://mathworld.wolfram.com/CapacityDimension.html

%% About the 'boxcount' package for Matlab
% The following examples illustrate how to use the Matlab package
% 'boxcount' to compute the fractal dimension of 1D, 2D or 3D sets, using
% the 'box-counting' method.
%
% The directory contains the main function 'boxcount', three sample images,
% and an additional function 'randcantor' to generate 1D, 2D and 3D
% generalized random Cantor sets.
%
% Type 'help boxcount' or 'help randcantor' for more details.


%% Box-counting of a 2D image
% Let's start with the image 'dla.gif', a 800x800 logical array (i.e., it
% contains only 0 and 1). It originates from a numerical simulation of a
% "Diffusion Limited Aggregation" process, in which particles move randomly
% until they hit a central seed.
% (see P. Bourke, http://local.wasp.uwa.edu.au/~pbourke/fractals/dla/ )
%{
bw_Voronoi=bw_images('Voronoi.png');
bw_Table=bw_images('Table.png');
bw_BrickWall=bw_images('BrickWall.png');
bw_StyloVertical=bw_images('StyloVertical.png');
bw_StyloHorizontal=bw_images('StyloHorizontal.png');
bw_Hexagon=bw_images('Hexagon.png');
bw_Cracks=bw_images('Cracks.png');
bw_Cracks2=bw_images('Cracks2.png');
%% Tau factor
imwrite(~rgb2gray(bw_Voronoi),'Voronoi.tif','tif');
imwrite(~rgb2gray(bw_Table),'Table.tif','tif');
imwrite(~rgb2gray(bw_BrickWall),'BrickWall.tif','tif');
imwrite(~rgb2gray(bw_StyloVertical),'StyloVertical.tif','tif');
imwrite(~rgb2gray(bw_StyloHorizontal),'StyloHorizontal.tif','tif');
imwrite(~rgb2gray(bw_Hexagon),'Hexagon.tif','tif');
imwrite(~rgb2gray(bw_Cracks),'Cracks.tif','tif');
imwrite(~rgb2gray(bw_Cracks2),'Cracks2.tif','tif');
%% 

%}
imwrite(rgb2gray(bw_Voronoi),'b_Voronoi.png');
imwrite(rgb2gray(bw_Table),'b_Table.png');
imwrite(rgb2gray(bw_BrickWall),'b_BrickWall.png');
imwrite(rgb2gray(bw_StyloVertical),'b_StyloVertical.png');
imwrite(rgb2gray(bw_StyloHorizontal),'b_StyloHorizontal.png');
imwrite(rgb2gray(bw_Hexagon),'b_Hexagon.png');
imwrite(rgb2gray(bw_Cracks),'b_Cracks.png');
imwrite(rgb2gray(bw_Cracks2),'b_Cracks2.png');
%%

close all;
files={bw_Voronoi,bw_Table,bw_BrickWall,bw_StyloVertical,bw_StyloHorizontal,bw_Hexagon,bw_Cracks,bw_Cracks2};
file_names={'bw_Voronoi','bw_Table','bw_BrickWall','bw_StyloVertical','bw_StyloHorizontal','bw_Hexagon','bw_Cracks','bw_Cracks2'};
for i=1:length(files)
    figure(i);
    c = rgb2gray(files{i});
    subplot(2,2,[1,2])
    imshow(~c)
    axis square
    colormap gray


%%
% Calling boxcount without output arguments simply displays N (the number
% of boxes needed to cover the set) as a function of R (the size of the
% boxes). If the set is a fractal, then a power-law  N = N0 * R^(-DF)
% should appear, with DF the fractal dimension (Kolmogorov capacity).
    subplot(2,2,3)
    boxcount(~c)

%%
% The result of the box count can be obtained using:

[n, r] = boxcount(~c);
loglog(r, n,'bo-', r, (r/r(end)).^(-2), 'r--');
xlabel('r');
ylabel('n(r)');
legend('actual box-count','space-filling box-count');

%%
% The red dotted line shows the scaling N(R) = R^-2 for comparision,
% expected for a space-filling 2D image. The discrepancy between the two
% curves indicates a possible fractal behaviour.


%% Local scaling exponent
% If the set has some fractal properties over a limited range of box size
% R, this may be appreciated by plotting the local exponent,
% D = - d ln N / ln R.  For this, use the option 'slope':
    subplot(2,2,4)
    boxcount(~c, 'slope')
    df = -diff(log(n))./diff(log(r))
    disp(file_names{i})
    disp(['Fractal dimension, Df = ' num2str(min(df(1:8)))]);
    disp(['Fractal dimension, Df = ' num2str(mean(df(1:5))) ' +/- ' num2str(std(df(1:5)))]);

end
%%
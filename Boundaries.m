function [Boundary_Matrix]= Boundaries(Rock_Matrix,Mineral_ID,Boundary_ID)
%{
This function recieves the Rock_Matrix, a mineral ID and a mineral 
boundary ID. The fuction returns the rock matrix with the mineral
boundaries classified.
%}
%%
Grain_Matrices = cell(1,3);
Grain_Matrices {1,1} = double(Rock_Matrix); %turn Rock_matrix to double
for i=2:3
    Grain_Matrices {1,i} = zeros(length(Rock_Matrix(:,1)),...
        (length(Rock_Matrix(1,:))));%initiallize grain matrices
end
%% This section solves the boundaries for 1st and last row, and column 
%% 1st row
for i=2:length(Rock_Matrix(1,:)) %solving the 1st row from right to left
    if (Rock_Matrix(1,i)==0 && ... %Grain Boundary
       (Rock_Matrix(1,i-1)==Mineral_ID || Grain_Matrices {1,2}(1,i-1)==Boundary_ID))
        Grain_Matrices {1,2}(1,i)=Boundary_ID; %neighbour to mineral or boundary
    end
end

for i=(length(Rock_Matrix(1,:))-1):-1:1 %solving the 1st row from left to right
    if (Rock_Matrix(1,i)==0 &&... %Grain Boundary
       (Rock_Matrix(1,i+1)==Mineral_ID || Grain_Matrices {1,2}(1,i+1)==Boundary_ID))
       Grain_Matrices {1,2}(1,i)=Boundary_ID;%neighbour to mineral or boundary
    end
end
%% last row
for i=2:length(Rock_Matrix(1,:)) %solving the last row from right to left
    if (Rock_Matrix(length(Rock_Matrix(:,1)),i)==0 && ...
       (Rock_Matrix(length(Rock_Matrix(:,1)),i-1)==Mineral_ID ...
       || Grain_Matrices {1,2}(length(Rock_Matrix(:,1)),i-1)==Boundary_ID))
        Grain_Matrices {1,2}(length(Rock_Matrix(:,1)),i)=Boundary_ID;
    end
end
for i=(length(Rock_Matrix(1,:))-1):-1:1 %solving the last row from left to right
    if (Rock_Matrix(length(Rock_Matrix(:,1)),i)==0 &&... %Grain Boundary
       (Rock_Matrix(length(Rock_Matrix(:,1)),i+1)==Mineral_ID ||...
       Grain_Matrices {1,2}(length(Rock_Matrix(:,1)),i+1)==Boundary_ID))
       Grain_Matrices {1,2}(length(Rock_Matrix(:,1)),i)=Boundary_ID;%neighbour to mineral or boundary
    end
end
%% first column
for i=2:length(Rock_Matrix(:,1)) %solving the first column from up to down
    if (Rock_Matrix(i,1)==0 && (Rock_Matrix(i-1,1)==Mineral_ID || ...
        Grain_Matrices {1,2}(i-1,1)==Boundary_ID))
        Grain_Matrices {1,2}(i,1)=Boundary_ID;
    end
end
for i=(length(Rock_Matrix(:,1))-1):-1:1 %solving the first column from down to up
    if (Rock_Matrix(i,1)==0 && (Rock_Matrix(i+1,1)==Mineral_ID || ...
        Grain_Matrices {1,2}(i+1,1)==Boundary_ID))
        Grain_Matrices {1,2}(i,1)=Boundary_ID;
    end
end
%% last column
for i=2:length(Rock_Matrix(:,1)) %solving the last column from up to down
    if (Rock_Matrix(i,length(Rock_Matrix(1,:)))==0 && ...
       (Rock_Matrix(i-1,length(Rock_Matrix(1,:)))==Mineral_ID ||...
        Grain_Matrices {1,2}(i-1,length(Rock_Matrix(1,:)))==Boundary_ID))
        Grain_Matrices {1,2}(i,length(Rock_Matrix(1,:)))=Boundary_ID;
    end
end
for i=(length(Rock_Matrix(:,1))-1):-1:1 %solving the last column from down to up
    if (Rock_Matrix(i,length(Rock_Matrix(1,:)))==0 && ...
       (Rock_Matrix(i+1,length(Rock_Matrix(1,:)))==Mineral_ID ||...
       Grain_Matrices {1,2}(i+1,length(Rock_Matrix(1,:)))==Boundary_ID))
       Grain_Matrices {1,2}(i,length(Rock_Matrix(1,:)))=Boundary_ID;
    end
end
        

%% solving for the matrix
for i=2:3
    %Grain_Matrices {1,i} = zeros(length(Rock_Matrix(:,1)),(length(Rock_Matrix(1,:))));%initiallize grain matrices
    for r = (2):(length(Rock_Matrix(:,1))-1) %from 2nd to one before last row
        for c = (2):(length(Rock_Matrix(1,:))-1) %2nd-one before last column
            if (Grain_Matrices {1,i-1}(r,c)==Mineral_ID || Grain_Matrices {1,i-1}(r,c)==Boundary_ID) %if the pixel contains the mineral or the mineral boundary
                if(Grain_Matrices {1,i-1}(r-1,c-1)==0 && Rock_Matrix(r-1,c-1)==0)
                    Grain_Matrices{1,i}(r-1,c-1)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r-1,c)==0 && Rock_Matrix(r-1,c)==0)
                    Grain_Matrices{1,i}(r-1,c)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r-1,c+1)==0 && Rock_Matrix(r-1,c+1)==0)
                    Grain_Matrices{1,i}(r-1,c+1)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r,c-1)==0 && Rock_Matrix(r,c-1)==0)
                    Grain_Matrices{1,i}(r,c-1)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r,c+1)==0 && Rock_Matrix(r,c+1)==0)
                   Grain_Matrices{1,i}(r,c+1)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r+1,c-1)==0 && Rock_Matrix(r+1,c-1)==0)
                    Grain_Matrices{1,i}(r+1,c-1)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r+1,c)==0 && Rock_Matrix(r+1,c)==0)
                    Grain_Matrices{1,i}(r+1,c)=Boundary_ID;
                end
                if(Grain_Matrices {1,i-1}(r+1,c+1)==0 && Rock_Matrix(r+1,c+1)==0)
                    Grain_Matrices{1,i}(r+1,c+1)=Boundary_ID;
                end
            end
        end
    end
    Grain_Matrices{1,i}=Grain_Matrices{1,i}+Grain_Matrices{1,i-1};
end
Boundary_Matrix=Grain_Matrices{1,i};
end
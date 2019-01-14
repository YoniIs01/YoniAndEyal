classdef ModelData
    properties
        RockType
        NumGrains
        DoloPercent
        RockSize
        RockFirstImage
        StartTime
        EndTime
        Steps
    end
    properties (Dependent)
        TotalTimeSteps
    end
    methods
        function value = get.TotalTimeSteps(this)
            value = length(this.Steps);
        end
        function this=ModelData(RockType,NumGrains,DoloPercent)
            this.RockType = RockType;
            this.NumGrains = NumGrains;
            this.DoloPercent = DoloPercent;
            this.StartTime = clock;
            this.Steps = Step.empty;
        end
        function SurfaceMatrix = GetSurfaceMatrixByStep(this,StepIndex)
            SurfaceMatrix = zeros(this.RockSize);
            SurfaceMatrix(this.Steps(StepIndex).SolutionContactLinearIndex) = 1;
        end
        function PlayMovie(this)
            Current_Rock_Matrix = this.RockFirstImage;
            Current_Rock_Matrix (1,:) =0;
            Rock_Frames(1) = im2frame(label2rgb(Current_Rock_Matrix));
           for i=2:length(this.Steps) 
               DissolvedIndexes = setdiff(this.Steps(i-1).SolutionContactLinearIndex,this.Steps(i).SolutionContactLinearIndex);
               Current_Rock_Matrix(DissolvedIndexes) = 0;
               CC=bwconncomp(Current_Rock_Matrix); %calculating the connected components (chunks)
                Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
                ,'UniformOutput',false); %calculates the relevant vectors that holds all 
                %the pixels that should be dissolved during this time step (including areas
                %outside bounding box)
                Current_Rock_Matrix([Temp{:}])=0; %dissolving the chunks
                Rock_Frames(i) = im2frame(label2rgb(Current_Rock_Matrix));
           end
           implay(Rock_Frames);
        end
        function PlaySurfaceMovie(this)
            for i = 1:length(this.Steps)
                Rock_Frames(i) = im2frame(label2rgb(this.GetSurfaceMatrixByStep(i)));
            end
            implay(Rock_Frames);
        end
    end
end

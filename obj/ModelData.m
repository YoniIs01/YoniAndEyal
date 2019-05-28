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
        FileName
        StepIds
        TimeStamp
        TotalTimeSteps
        TotalDissolution
        MechanicalDissolutionPercent
        ChemicalDissolutionPercent
    end
    methods
%         Dependent Properties get functions
        function value = get.TimeStamp(this)
            value = strcat(num2str(this.StartTime(1)),'-',num2str(this.StartTime(2)),'-',num2str(this.StartTime(3)),'_',num2str(this.StartTime(4)),':',num2str(this.StartTime(5)),':',num2str(this.StartTime(6)));
        end
        function value = get.StepIds(this)
            value = [this.Steps.StepId];
        end
        function value = get.FileName(this)
            value = strcat('ModelData_',strrep(this.TimeStamp,':',''),'.mat');
        end
        function value = get.TotalTimeSteps(this)
            value = length(this.Steps);
        end
        function value = get.TotalDissolution(this)
            value = sum([this.Steps.Mechanical_Dissolution]) + sum([this.Steps.Chemical_Dissolution]);
        end
        function value = get.MechanicalDissolutionPercent(this)
            value = sum([this.Steps.Mechanical_Dissolution])/this.TotalDissolution;
        end
        function value = get.ChemicalDissolutionPercent(this)
            value = sum([this.Steps.Chemical_Dissolution])/this.TotalDissolution;
        end
        
%         Constructor
        function this=ModelData(RockType,NumGrains,DoloPercent)
            this.RockType = RockType;
            this.NumGrains = NumGrains;
            this.DoloPercent = DoloPercent;
            this.StartTime = clock;
            this.Steps = Step.empty;
        end
        
%         Methods
        function SurfaceMatrix = GetSurfaceMatrixByStep(this,StepIndex)
            SurfaceMatrix = zeros(this.RockSize);
            SurfaceMatrix(this.Steps(StepIndex).SolutionContactLinearIndex) = 1;
        end
        function PlayMovie(this)
            Current_Rock_Matrix = this.RockFirstImage;
            Current_Rock_Matrix (1,:) =0;
            Current_Rock_Matrix_Crop = Current_Rock_Matrix(1:420-129,109:560-109);
            Rock_Frames(1) = im2frame(label2rgb(Current_Rock_Matrix_Crop));
            j = 2;
           for i=2:length(this.Steps) 
               DissolvedIndexes = setdiff(this.Steps(i-1).SolutionContactLinearIndex,this.Steps(i).SolutionContactLinearIndex);
               Current_Rock_Matrix(DissolvedIndexes) = 0;
               CC=bwconncomp(Current_Rock_Matrix); %calculating the connected components (chunks)
                Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
                ,'UniformOutput',false); %calculates the relevant vectors that holds all 
                %the pixels that should be dissolved during this time step (including areas
                %outside bounding box)
                Current_Rock_Matrix([Temp{:}])=0; %dissolving the chunks
                if (mod(i,8) == 0)
                    Cropped_Current_Rock_Matrix = Current_Rock_Matrix(1:420-129,109:560-109);
                    Rock_Frames(j) = im2frame(label2rgb(Cropped_Current_Rock_Matrix));
                    j = j+1;
                end
           end
           implay(Rock_Frames);
        end
        function PlaySurfaceMovie(this)
            j = 1;
            for i = 1:8:length(this.Steps)
                SurfaceMatrix = this.GetSurfaceMatrixByStep(i);
                Rock_Frames(j) = im2frame(label2rgb(SurfaceMatrix(1:420-129,109:560-109)));
                j = j + 1;
            end
            implay(Rock_Frames);
        end
        function PlayCombinedMovie(this, SaveToDir)
            Current_Rock_Matrix = this.RockFirstImage;
            Current_Rock_Matrix (1,:) =0;
            Current_Rock_Matrix_Crop = Current_Rock_Matrix(1:420-129,109:560-109);
            SurfaceMatrix = this.GetSurfaceMatrixByStep(1);
            Cropped_SurfaceMatrix = SurfaceMatrix(1:420-129,109:560-109);
            Rock_Frames(1) = im2frame(label2rgb([Current_Rock_Matrix_Crop Cropped_SurfaceMatrix]));
            j = 2;
           for i=2:length(this.Steps) 
               DissolvedIndexes = setdiff(this.Steps(i-1).SolutionContactLinearIndex,this.Steps(i).SolutionContactLinearIndex);
               Current_Rock_Matrix(DissolvedIndexes) = 0;
               CC=bwconncomp(Current_Rock_Matrix); %calculating the connected components (chunks)
                Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
                ,'UniformOutput',false); %calculates the relevant vectors that holds all 
                %the pixels that should be dissolved during this time step (including areas
                %outside bounding box)
                Current_Rock_Matrix([Temp{:}])=0; %dissolving the chunks
                if (mod(i,8) == 0)
                    Cropped_Current_Rock_Matrix = Current_Rock_Matrix(1:420-129,109:560-109);
                    SurfaceMatrix = this.GetSurfaceMatrixByStep(i);
                    Cropped_SurfaceMatrix = SurfaceMatrix(1:420-129,109:560-109);
                    Rock_Frames(j) = im2frame(label2rgb([Cropped_Current_Rock_Matrix  Cropped_SurfaceMatrix]));
                    j = j+1;
                end
           end
           implay(Rock_Frames);
           if (SaveToDir)
               v = VideoWriter(strcat(SaveToDir,this.FileName),'MPEG-4');
               open(v);
               writeVideo(v,Rock_Frames);
               close(v);
           end
        end
        function PlotChunckSizeHistogram(this,threshold,binsize)
            if nargin<2
              threshold =30;
              binsize = 30;
            end
            Events = [this.Steps.ChunckEvents];
            Areas = [Events.Area];
            histogram(Areas(Areas>threshold),[1:binsize:max(Areas)]);
            set(gca,'fontsize',16);
            xlabel('Detachment size (pixles)');
            ylabel('Frequency')
            hold off;
        end
        function PlotDissolutionByTimeStep(this)
            figure;
            hold on;
            plot(this.StepIds,cumsum([this.Steps.Mechanical_Dissolution]));
            plot(this.StepIds,cumsum([this.Steps.Chemical_Dissolution]));
            plot(this.StepIds,[this.Steps.SolutionContactArea]*20);
            set(gca,'fontsize',16);
            legend('Mechanical Dissolution','Chemical Dissolution','Solution Contact Area*20','location','best');
            xlabel('Timesteps');
            ylabel('Weathering (pixels)')
            hold off;
        end
        function PlotFFT(this)
%             figure;
%             plot(this.StepIds,[this.Steps.SolutionContactArea],'Ok')
%             xlabel('Timesteps');
%             ylabel('SolutionContactArea');
%             Y=fft([this.Steps.SolutionContactArea]);
%             NormalMag=2.*((abs(Y(2:length(Y)/2)))/(length(Y)/2));
%             %using the squared magnitude to get rid of low signals
%             SquaredMag=(2.*(abs(Y(2:length(Y)/2)).^2))./((length(Y)/2)^2);
%             %calculating the frequency
%             dage=1;
%             f=(2:(length(Y)/2))./(length(Y)*dage);
%             [pk_1,f0_1] = findpeaks(SquaredMag,f,'MinPeakHeight',0.03);
%             [pk_2,f0_2] = findpeaks(NormalMag,f,'MinPeakHeight',0.1);
%             figure;
%             plot(f,NormalMag,'b',f0_2,pk_2,'o',f,SquaredMag,'r',f0_1,pk_1,'o');
%             xlabel('Frequency'); ylabel('2|Xn|^2/n^2 , 2|Xn|/n');
%             title('Spectral analysis using fft');
%             legend('2|Xn|/n','peaks','2|Xn|^2/n^2','peaks');
%             xlim([0,.1])
            
          
            %making sure there are no gaps, and forcing an evenly sampled data
            newTimeSteps=linspace(min(this.StepIds),max(this.StepIds),100*length(this.StepIds));
            newContactArea=interp1(this.StepIds,[this.Steps.SolutionContactArea],newTimeSteps,'pchip');
            hold on;
%             plot(newTimeSteps,newContactArea,'r')
            legend ('data','interpolation')
            %% calculationg the fft
            Y=fft(newContactArea);
%             NormalMag=2.*((abs(Y(2:length(Y)/2)))/(length(Y)/2));
            %using the squared magnitude to get rid of low signals
            SquaredMag=(2.*(abs(Y(2:length(Y)/2)).^2))./((length(Y)/2)^2);
            %calculating the frequency
            dage=newTimeSteps(2)-newTimeSteps(1);
            f=(2:(length(Y)/2))./(length(Y)*dage);
            [pk_1,f0_1] = findpeaks(SquaredMag,f,'SortStr','descend','NPeaks',5);
%             [pk_2,f0_2] = findpeaks(NormalMag,f,'MinPeakHeight',0.1);
            figure;
%             f,NormalMag,'b',f0_2,pk_2,'o',
            f0_1 = f0_1(pk_1>=mean(pk_1));
            pk_1 = pk_1(pk_1>=mean(pk_1));
            SquaredMag(SquaredMag<mean(SquaredMag)) = 0;
            plot(f,SquaredMag,'r',f0_1,pk_1,'or');
            xlabel('Frequency'); ylabel('2|Xn|^2/n^2 , 2|Xn|/n');
            title('Spectral analysis using fft');
            legend('2|Xn|/n','peaks','2|Xn|^2/n^2','peaks');
            xlim([0,.1])
            
        end
    end
end

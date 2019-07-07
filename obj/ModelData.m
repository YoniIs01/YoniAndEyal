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
    SolutionOutOfBBoxIndex
    MeanChunckSize
end
properties (Constant)
    ModelDataExcelPath = "D:\Program Files\Results Archive\complete run 2\2019-6-3_10-9ModelResults.xlsx";
    RockTypes = struct('Voronoi',1,'Table',2,'Brickwall',3,'Stylolites',4,'Hex',5,'Cracks',6)
end

methods (Static)
    function PathList = QueryModelDataPath(QueryString)
        [ndata, text, alldata] = xlsread(ModelData.ModelDataExcelPath);
        Columns = text(1,:);
        PathColumn = find(strcmp(Columns,'WS_FileName'));
        NameValues = strsplit(QueryString,';');
        RefinedIndexes  = [];
        for i = 1:length(NameValues)
         NameValue = strsplit(NameValues{i},'=');
         Name = NameValue{1};
         Value = NameValue{2};
         if any(strcmp(Columns,Name))
            ColIndex = find(strcmp(Columns,Name));
            RefinedIndexes = [RefinedIndexes find(ndata(:,ColIndex) == str2double(Value))];
         end
        end
        PathList = text(RefinedIndexes,PathColumn);
    end
    function PlotGrainDetachmentAverageProbality(QueryString)
        PathList = ModelData.QueryModelDataPath(QueryString);
        ModulesNumber =  length(PathList);
        BinSize = 30;
        ProbalityPerBin = [];
        for i =1:ModulesNumber
            load(PathList{i});
            M = Model_Data;
            e = [M.Steps.ChunckEvents];
            figure;
            histobj = histogram([e.Area],'BinWidth',BinSize,'Normalization','probability');

            ProbalityPerStep = [];
            for j = 1:histobj.NumBins
                p = histobj.Values(j);
                if length(ProbalityPerBin) < j
                    ProbalityPerBin(j) = 0;
                end
                ProbalityPerBin(j) = ProbalityPerBin(j) + p;
                ProbalityPerStep(j) = p;
            end
            close gcf;
        end

        MeanProbalityPerBin = ProbalityPerBin/ModulesNumber;
        MinRepeats = [];
        for j = 1:length(ProbalityPerBin)
            NRepeat = 1;
            Success = geocdf(NRepeat,MeanProbalityPerBin(j));
            while Success<0.7
                NRepeat = NRepeat + 1;
                Success = geocdf(NRepeat,MeanProbalityPerBin(j));
            end
            MinRepeats(j) = NRepeat;
        end

        XBarValues = (1:length(MeanProbalityPerBin))*BinSize - BinSize/2;
        yyaxis left
        bar(XBarValues(2:end),MeanProbalityPerBin(2:end),1,'FaceColor','w','EdgeColor',[0 .5 .5],'LineWidth',1.5);
        binranges = round(linspace(min(XBarValues(2:end)), max(XBarValues(2:end)),length(XBarValues)));
        set(gca,'XTick',binranges)
        set(gca,'fontsize',18,'ycolor',[0 .5 .5]);
        xlabel('Detachment size [Pixels]','fontsize',18);
        ylabel('Detachment Probality','fontsize',18);
%         yyaxis right
%         bar(XBarValues(2:end),MinRepeats(2:end),1,'FaceColor','w','EdgeColor',[.5 .5 .5],'LineWidth',1.5);
%         ylabel('#Steps to detachment','fontsize',18);
    end
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
    function value = get.SolutionOutOfBBoxIndex(this)
        S = zeros(this.RockSize);
        for i = 2:this.TotalTimeSteps
            S(this.Steps(i).SolutionContactLinearIndex) = 1;
            [row col] = find(S);
            if (max(row) > 291)
                break
            end
        end
        
        value = i;
    end
    function value = get.MeanChunckSize(this)
        e = [this.Steps.ChunckEvents];
        a = [e.Area];
        value = mean(a);
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
    function SolutionUnderBBox = GetSolutionUnderBBox(this)
        S = zeros(this.RockSize);
        SolutionUnderBBox(1) = 0;
        for i = 2:this.TotalTimeSteps
            S(this.Steps(i).SolutionContactLinearIndex) = 1;
            [row col] = find(S);
            SolutionUnderBBox(i) = sum(row > 291);
        end
    end
    
    function SurfaceMatrix = GetSurfaceMatrixByStep(this,StepIndex)
        SurfaceMatrix = zeros(this.RockSize);
        SurfaceMatrix(this.Steps(StepIndex).SolutionContactLinearIndex) = 1;
    end
    function Rock_Matrixes = GetRockMatrixesByStep(this)
        Rock_Matrixes = {};
        i = 1;
        Current_Rock_Matrix = this.RockFirstImage;
        Current_Rock_Matrix (1,:) =0;
        Rock_Matrixes{i} = Current_Rock_Matrix;
        for i=2:length(this.Steps)
            DissolvedIndexes = setdiff(this.Steps(i-1).SolutionContactLinearIndex,this.Steps(i).SolutionContactLinearIndex);
            Current_Rock_Matrix(DissolvedIndexes) = 0;
            CC=bwconncomp(Current_Rock_Matrix); %calculating the connected components (chunks)
            Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
                ,'UniformOutput',false); %calculates the relevant vectors that holds all
            %the pixels that should be dissolved during this time step (including areas
            %outside bounding box)
            Current_Rock_Matrix([Temp{:}])=0; %dissolving the chunks
            Rock_Matrixes{i} = Current_Rock_Matrix;
        end
        Current_Rock_Matrix(this.Steps(i).SolutionContactLinearIndex) = 0;
        CC=bwconncomp(Current_Rock_Matrix); %calculating the connected components (chunks)
        Temp=cellfun(@transpose,CC.PixelIdxList(2:length(CC.PixelIdxList))...
            ,'UniformOutput',false); %calculates the relevant vectors that holds all
        %the pixels that should be dissolved during this time step (including areas
        %outside bounding box)
        Current_Rock_Matrix([Temp{:}])=0; %dissolving the chunks
        Rock_Matrixes{i+1} = Current_Rock_Matrix;
    end
    function PlayMovie(this)
        Rock_Matrixes = this.GetRockMatrixesByStep();
        j = 1;
        for i=1:length(Rock_Matrixes)
            if (mod(i,8) == 0)
                RGB_Current_Rock_Matrix = label2rgb(Rock_Matrixes{i});
                Rock_Frames(j) = im2frame(RGB_Current_Rock_Matrix(1:420-129,109:560-109,:));
                j = j+1;
            end
        end
        RGB_Current_Rock_Matrix = label2rgb(Rock_Matrixes{i});
        Rock_Frames(j) = im2frame(RGB_Current_Rock_Matrix(1:420-129,109:560-109,:));
        implay(Rock_Frames);
%         v=VideoWriter(this.FileName,'MPEG-4');
%         v.FrameRate=100;
%         v.Quality=99;
%         open(v)
%         writeVideo(v,Rock_Frames);
%         close(v)
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
        Rock_Matrixes = this.GetRockMatrixesByStep();
        j = 1;
        for i=1:length(this.Steps)
           if (mod(i,8) == 0)
                RGB_Current_Rock_Matrix = label2rgb(Rock_Matrixes{i});
                RGB_SurfaceMatrix = label2rgb(this.GetSurfaceMatrixByStep(i));
                Rock_Frames(j) = im2frame([RGB_Current_Rock_Matrix(1:420-129,109:560-109,:) RGB_SurfaceMatrix(1:420-129,109:560-109,:)]);
                j = j+1;
           end
        end
        RGB_Current_Rock_Matrix = label2rgb(Rock_Matrixes{i+1});
        RGB_SurfaceMatrix = label2rgb(zeros(size(this.GetSurfaceMatrixByStep(i))));
        Rock_Frames(j) = im2frame([RGB_Current_Rock_Matrix(1:420-129,109:560-109,:) RGB_SurfaceMatrix(1:420-129,109:560-109,:)]);
        implay(Rock_Frames);
%         if (SaveToDir)
%             v = VideoWriter(strcat(SaveToDir,this.FileName),'MPEG-4');
%             open(v);
%             writeVideo(v,Rock_Frames);
%             close(v);
%         end
    end
    function PlotChunckSizeHistogram(this,threshold,binsize)
        if nargin<2
            threshold =30;
            binsize = 30;
        end
        Events = [this.Steps.ChunckEvents];
        Areas = [Events.Area];
        histogram(Areas(Areas>threshold),[1:binsize:max(Areas)]);
        set(gca,'fontsize',18);
        xlabel('Detachment size (pixles)','fontsize',18);
        ylabel('Frequency','fontsize',18)
        hold off;
    end
    function PlotCumDissolutionByTimeStep(this)
        figure;
        hold on;
        plot(this.StepIds,cumsum([this.Steps.Mechanical_Dissolution]));
        plot(this.StepIds,cumsum([this.Steps.Chemical_Dissolution]));
        plot(this.StepIds,[this.Steps.SolutionContactArea]*10);
        set(gca,'fontsize',18);
        legend('Mechanical Dissolution','Chemical Dissolution','Solution Contact Area*10','location','best');
        xlabel('Timesteps','fontsize',18);
        ylabel('Weathering (pixels)','fontsize',18)
        hold off;
    end
    function PlotDissolutionByTimeStep(this)
        figure;
        hold on;
        plot(this.StepIds,[this.Steps.Mechanical_Dissolution]);
        plot(this.StepIds,[this.Steps.Chemical_Dissolution]);
        set(gca,'fontsize',16);
        legend('Mechanical Dissolution','Chemical Dissolution','Solution Contact Area*20','location','best');
        xlabel('Timesteps');
        ylabel('Weathering (pixels)')
        hold off;
    end
    function PlotFFT(this)
        %making sure there are no gaps, and forcing an evenly sampled data
        newTimeSteps=linspace(min(this.StepIds),max(this.StepIds),100*length(this.StepIds));
        newContactArea=interp1(this.StepIds,[this.Steps.SolutionContactArea],newTimeSteps,'pchip');
        %% calculationg the fft
        Y=fft(newContactArea(newContactArea>mean(newContactArea)));
        %using the squared magnitude to get rid of low signals
        SquaredMag=(2.*(abs(Y(2:length(Y)/2)).^2))./((length(Y)/2)^2);
        %calculating the frequency
        dage=newTimeSteps(2)-newTimeSteps(1);
        f=(2:(length(Y)/2))./(length(Y)*dage);
        [pk_1,f0_1] = findpeaks(SquaredMag,f,'SortStr','descend','NPeaks',5);
        figure;
        plot(f,SquaredMag,'k',f0_1,pk_1,'or');
        text(f0_1,pk_1,num2str(round(1./f0_1(:))),'fontsize',18);
        xlabel('Frequency','fontsize',18); ylabel('PSD','fontsize',18);
        set(gca,'fontsize',18);
        %title('Spectral analysis using fft','fontsize',18);
        xlim([0,.1])
    end
    function PlotDissolutionFFT(this)
        %making sure there are no gaps, and forcing an evenly sampled data
        newTimeSteps=linspace(min(this.StepIds),max(this.StepIds),100*length(this.StepIds));
        newContactArea=interp1(this.StepIds,[this.Steps.TotalDissolution],newTimeSteps,'pchip');
        %% calculationg the fft
        Y=fft(newContactArea(newContactArea>mean(newContactArea)));
        %using the squared magnitude to get rid of low signals
        SquaredMag=(2.*(abs(Y(2:length(Y)/2)).^2))./((length(Y)/2)^2);
        %calculating the frequency
        dage=newTimeSteps(2)-newTimeSteps(1);
        f=(2:(length(Y)/2))./(length(Y)*dage);
        [pk_1,f0_1] = findpeaks(SquaredMag,f,'SortStr','descend','NPeaks',5);
        figure;
        plot(f,SquaredMag,'k',f0_1,pk_1,'or');
        text(f0_1,pk_1,num2str(round(1./f0_1(:))));
        xlabel('Frequency'); ylabel('2|Xn|^2/n^2 , 2|Xn|/n');
        title('Spectral analysis using fft');
        xlim([0,.1])

    end
end
end

classdef ModelData
properties
    RockType
    NumGrains
    DoloPercent
    Orientation
    RockFirstImage
    StartTime
    EndTime
    Steps
end
properties (Dependent)
    FileName
    FilePath
    RockImageFile
    OriginalRockGrainAreas
    RockSize
    StepIds
    TimeStamp
    TotalTimeSteps
    TotalDissolution
    MechanicalDissolutionPercent
    ChemicalDissolutionPercent
    SolutionOutOfBBoxStepId
    SolutionContactStabilizedStepId
    SolutionContactStabilizedLastStepId
    MeanChunckSize
    WeightedMeanChunckSize
end
properties (Constant)
    ModelDataPath = "D:\Program Files\Results Archive\FinalResults\";
    ModelDataExcelPath = "D:\Program Files\Results Archive\FinalResults\FinalModelResults.xlsx";
   
    %ModelDataExcelPath = "D:\Program Files\Results Archive\FinalResults\FinalModelResults.xlsx";
    RockTypes = struct('Voronoi',1,'Table',2,'Brickwall',3,'Stylolites',4,'Hex',5,'Cracks',6,'Simon',7);
    RockIds = ["Voronoi" "Table" "Brickwall" "Stylolites" "Hex" "Cracks" "Simon"];
end

methods (Static)
    %        Query Models etc..
    function PathList = QueryModelDataPath(QueryString) % returns the list of filenames of relevant model datas
        [ndata, text, alldata] = xlsread(ModelData.ModelDataExcelPath);
        Columns = text(1,:);
        PathColumn = find(strcmp(Columns,'WS_FileName'));
        RefinedData = ModelData.QueryExcel(QueryString);
        PathList = RefinedData(:,PathColumn);
    end  
    function Model_Data = Load(FileName) %loads a single model simulation data
        load(strcat(ModelData.ModelDataPath,FileName),'Model_Data');
    end  
    function Model_Data = LoadFromQuery(QueryString,Index)% Loads the relevant model datas
%         EXAMPLE:
%         for i=1:length(ModelData.QueryModelDataPath('RockType=3'))
%           m = ModelData.LoadFromQuery('RockType=3',i)
%         end
        ModelList = ModelData.QueryModelDataPath(QueryString);
        Model_Data = ModelData.Load(ModelList{Index});
    end  
    function RefinedData = QueryExcel(QueryString) %recieves a ; delimited query, with excel column headers and values
        % returns the relevant rows in excel
        % EXAMPLE: 'RockType=3;NumGrains=800;Orientation~0.5'
        [ndata, text, alldata] = xlsread(ModelData.ModelDataExcelPath);
        Columns = text(1,:);
        NameValues = strsplit(QueryString,';');
        if isempty(QueryString)
            NameValues = [];
        end
        RefinedIndexes  = [2:size(alldata,1)];
        for i = 1:length(NameValues)
         NameValue = strsplit(NameValues{i},'=');
         Operator = '=';
         if length(NameValue) ~= 2
             NameValue = strsplit(NameValues{i},'~');
             Operator = '~';
         end
         Name = NameValue{1};
         Value = NameValue{2};
         if any(strcmp(Columns,Name))
            ColIndex = find(strcmp(Columns,Name));
            if (strcmp(class(alldata{2,ColIndex}),'char'))
                if (Operator == '=')
                    RefinedIndexes = intersect(RefinedIndexes,find(strcmp([alldata(:,ColIndex)], Value)));
                else
                    RefinedIndexes = intersect(RefinedIndexes,find(~strcmp([alldata(:,ColIndex)], Value)));
                end
                
            else
                if (Operator == '=')
                    RefinedIndexes = intersect(RefinedIndexes,find(abs([alldata{2:end,ColIndex}] - str2double(Value)) < 0.001) + 1);
                else
                    RefinedIndexes = intersect(RefinedIndexes,find(abs([alldata{2:end,ColIndex}] - str2double(Value)) > 0.001) + 1);
                end
                
            end
         end
        end
        RefinedData = alldata(RefinedIndexes,:);
    end
  
    %        StaticCalcMethods
    function PlotGrainDetachmentAverageProbality(QueryString)
        PathList = ModelData.QueryModelDataPath(QueryString);
        ModulesNumber =  length(PathList);
        BinSize = 100;
        ProbalityPerBin = [];
        for i =1:ModulesNumber
            load(strcat(ModelData.ModelDataPath,PathList{i}));
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
        subplot(2,1,1);
        bar(XBarValues(2:end),MeanProbalityPerBin(2:end),1,'FaceColor','w','EdgeColor',[0 .5 .5],'LineWidth',1.5);
        binranges = round(linspace(min(XBarValues(2:end)), max(XBarValues(2:end)),length(XBarValues)));
        set(gca,'XTick',binranges)
        set(gca,'fontsize',16,'ycolor',[0 .5 .5]);
        xlabel('Detachment size [Pixels]','fontsize',18);
        ylabel('Detachment Probality','fontsize',18);
        subplot(2,1,2);
        bar(XBarValues(2:end),MinRepeats(2:end),1,'FaceColor','w','EdgeColor',[.5 .5 .5],'LineWidth',1.5);
        ylabel('#Steps to detachment','fontsize',18);
        xlabel('Detachment size [Pixels]','fontsize',18);
        set(gca,'fontsize',13)
    end
end

methods
%%         Dependent Properties get functions
    function value = get.TimeStamp(this)
        value = strcat(num2str(this.StartTime(1)),'-',num2str(this.StartTime(2)),'-',num2str(this.StartTime(3)),'_',num2str(this.StartTime(4)),':',num2str(this.StartTime(5)),':',num2str(this.StartTime(6)));
    end
    function value = get.StepIds(this)
        value = [this.Steps.StepId];
    end
    function value = get.FileName(this)
        value = strcat('ModelData_',strrep(this.TimeStamp,':',''),'.mat');
    end
    function value = get.FilePath(this)
        value = strcat(this.ModelDataPath,'ModelData_',strrep(this.TimeStamp,':',''),'.mat');
    end
    function value = get.RockImageFile(this)%needs to be updated
        switch (this.RockType)
            case 4
                switch (this.Orientation)
                    case 'Horizontal'
                        switch (this.NumGrains)
                            case 1; value = 'r2%.tiff';
                            case 2; value = 'r21%.tiff';
                            case 3; value = 'r5%.tiff';
                            case 4; value = 'r13%.tiff';
                            case 5; value = 'r14%.tiff';
                            case 6; value = 'r16%.tiff';
                        end
                    case 'Vertical'
                        switch (this.NumGrains)
                            case 1; value = 't2%.tiff';
                            case 2; value = 't3%.tiff';
                            case 3; value = 't6%.tiff';
                            case 4; value = 't13%.tiff';
                            case 5; value = 't131%.tiff';
                            case 6; value = 't16%.tiff';
                        end
                end
            case 6
                switch this.NumGrains
                    case 0; value = 'LowDenseCracks.jpg';
                    case 1; value = 'HighDenseCracks.jpg';
                end
            otherwise
                value = '';
        end
    end
    function value = get.OriginalRockGrainAreas(this)
        BW = this.RockFirstImage(1:420-129,109:560-109) == mode(this.RockFirstImage(1:420-129,109:560-109),'all');
        CC = bwconncomp(BW);
        if (CC.NumObjects == 1)
            CC = bwconncomp(BW == 0);
        end
        value = [cellfun(@(x) length(x),CC.PixelIdxList)];
    end
    function value = get.RockSize(this)
        value = size(this.RockFirstImage);
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
    function value = get.SolutionOutOfBBoxStepId(this)
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
    function value = get.SolutionContactStabilizedStepId(this)
        StabilizedContactArea = mean([this.Steps.SolutionContactArea])-std([this.Steps.SolutionContactArea]);
        value = find([this.Steps.SolutionContactArea] > StabilizedContactArea,1);
    end
    function value = get.SolutionContactStabilizedLastStepId(this)
        StabilizedContactArea = mean([this.Steps.SolutionContactArea])-std([this.Steps.SolutionContactArea]);
        value = find([this.Steps.SolutionContactArea] > StabilizedContactArea,1,'last');
    end
    function value = get.MeanChunckSize(this)
        e = [this.Steps.ChunckEvents];
        a = [e.Area];
        a = a(a>10);
        value = mean(a);
    end
    function value = get.WeightedMeanChunckSize(this)
        e = [this.Steps.ChunckEvents];
        a = [e.Area];
        a = a(a>10);
        value = mean(a.^2)/mean(a);
    end
%%         Constructor
    function this=ModelData(RockType,NumGrains,DoloPercent)
        this.RockType = RockType;
        this.NumGrains = NumGrains;
        this.DoloPercent = DoloPercent;
        this.StartTime = clock;
        this.Steps = Step.empty;
    end
    function SaveWS(this)
        Model_Data = this;
        save(this.FilePath,'Model_Data','-v7.3');
    end

%%         Methods
    %         Visual 
    function ShowRockFirstFrameInBB(this)
        figure;
        imshow(label2rgb(this.RockFirstImageInBB()));
    end
    function FirstImage = RockFirstImageInBB(this)
        FirstImage = this.RockFirstImage(1:420-129,109:560-109,:);
    end
    function props = GetInBBObjectsProps(this)
        FirstImage = this.RockFirstImageInBB;
        FirstImage = FirstImage == min(FirstImage(:));
        CC=bwconncomp(FirstImage);
        props = regionprops(CC,'all');
    end
    function P2DMean = GetPerimeterToDiameterMean(this)
        Mean = mean([this.GetInBBObjectsProps().Perimeter]./[this.GetInBBObjectsProps().EquivDiameter]);
        Std = std([this.GetInBBObjectsProps().Perimeter]./[this.GetInBBObjectsProps().EquivDiameter]);
        P2DMean = [Mean Std];
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
    function SurfaceMatrix = GetSurfaceMatrixByStep(this,StepIndex)
        SurfaceMatrix = zeros(this.RockSize);
        SurfaceMatrix(this.Steps(StepIndex).SolutionContactLinearIndex) = 1;
    end
    function PlayMovie(this)
        Rock_Matrixes = this.GetRockMatrixesByStep();
        j = 1;
        for i=1:length(Rock_Matrixes)
            if (mod(i,round(length(Rock_Matrixes)/150)) == 0)
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
    function PlayCombinedMovie(this)
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
    end
    function SolutionUnderBBox = GetSolutionUnderBBox(this)
        S = zeros(this.RockSize);
        SolutionUnderBBox(1) = 0;
        for i = 2:this.TotalTimeSteps
            S(this.Steps(i).SolutionContactLinearIndex) = 1;
            [row col] = find(S);
            SolutionUnderBBox(i) = sum(row > 291);
        end
    end
    
    %         Plots
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
    function InitialDistribution = GetInitialDistribution(this)
        props = this.GetInBBObjectsProps();
        GrainAreas = [props.Area];
        InitialDistribution = reweightByMass(GrainAreas);
    end
    function PlotInitialDistribution(this)
        histogram(this.GetInitialDistribution(),15);
    end
    function DetachedDistribution = GetDetachedDistribution(this)
        ChunckEvents = [this.Steps.ChunckEvents];
        ChunckAreas = [ChunckEvents.Area];
        DetachedAreas = ChunckAreas(ChunckAreas>10);
        DetachedDistribution = reweightByMass(DetachedAreas);
    end
    function PlotDetachedDistribution(this)
        histogram(this.GetDetachedDistribution(),15);
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
    function PlotCompareRoughnessToDetachment(this)
        a = [this.Steps.SolutionContactArea];
        b = [this.Steps.Mechanical_Dissolution];
        figure;
        fs =this.SolutionContactStabilizedStepId;
        ls = this.SolutionContactStabilizedLastStepId;
        plot(fs:ls-1,abs(diff(a(fs:ls)))*3);
        hold on;
        plot(fs:ls,b(fs:ls));
    end
    function Peaks = PlotContactAreaFFT(this)
        StabilizedIndexes = this.SolutionContactStabilizedStepId:this.SolutionContactStabilizedLastStepId;
        md = [this.Steps.SolutionContactArea];
        md = md(StabilizedIndexes);
        Y=fft(md);
        PosY = 2*Y(2:floor(length(Y)/2))/length(Y);
        dt=1;
        f=(2:(length(Y)/2))./(length(Y)*dt);
        
        Magnitude = abs(PosY);
        [peaks,frequencies] = findpeaks(Magnitude,f,'SortStr','descend');
        Threshold = mean(peaks) + 2*std(peaks);
        HighPeakIndexes = (peaks > Threshold);
        TopPeaks = peaks(HighPeakIndexes)';
        TopFrequencies = frequencies(HighPeakIndexes)';
        TopPeaks = TopPeaks (1./TopFrequencies > 5);
        TopFrequencies = TopFrequencies (1./TopFrequencies > 5);
%         figure;
%         plot(f,Magnitude,'k',TopFrequencies,TopPeaks,'or');
%         text(TopFrequencies,TopPeaks,num2str(round(1./TopFrequencies)));
%         xlabel('Frequency'); ylabel('2|Xn|^2/n^2 , 2|Xn|/n');
%         title('Spectral analysis using fft');
        if (length(TopFrequencies) == 0) 
            Peaks = [];
        else
            Peaks = sortrows([1./TopFrequencies TopPeaks (TopPeaks - mean(peaks))/std(peaks)],1,'descend');
        end
    end
    function Peaks = PlotMechanicalDissolutionFFT(this)
        %% Calculates Mechanical Dissolution FFT and returns Most Significant Peaks (2STD above Mean) and STD  
        % calculationg the fft
        md = [this.Steps.Mechanical_Dissolution];
        ids = arrayfun(@(s) (sum([s.ChunckEvents.Area] > 10) == 0),this.Steps);
        md(ids) = 0;
        mdc = zeros(size(md));
%         for i = 1:length(md)
%             mdc(i) = sum(md==md(i));
%         end
%         md(mdc == 1) = 0;
        Y=fft(md);
        PosY = 2*Y(2:floor(length(Y)/2))/length(Y);
        dt=1;
        f=(2:(length(Y)/2))./(length(Y)*dt);
        
        Magnitude = abs(PosY);
        [peaks,frequencies] = findpeaks(Magnitude,f,'SortStr','descend');
        Threshold = mean(peaks) + 2*std(peaks);
        HighPeakIndexes = (peaks > Threshold);
        TopPeaks = peaks(HighPeakIndexes)';
        TopFrequencies = frequencies(HighPeakIndexes)';
        TopPeaks = TopPeaks (1./TopFrequencies > 5);
        TopFrequencies = TopFrequencies (1./TopFrequencies > 5);
%         figure;
%         plot(f,Magnitude,'k',TopFrequencies,TopPeaks,'or');
%         text(TopFrequencies,TopPeaks,num2str(round(1./TopFrequencies)));
%         xlabel('Frequency'); ylabel('2|Xn|^2/n^2 , 2|Xn|/n');
%         title('Spectral analysis using fft');
        if (length(TopFrequencies) == 0) 
            Peaks = [];
        else
            Peaks = sortrows([1./TopFrequencies TopPeaks (TopPeaks - mean(peaks))/std(peaks)],1,'descend');
        end
    end
end
end

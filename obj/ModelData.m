classdef ModelData
    properties
        RockType
        NumGrains
        DoloPercent
        StartTime
        EndTime
        Steps
    end
    methods
        function this=ModelData(RockType,NumGrains,DoloPercent)
            this.RockType = RockType;
            this.NumGrains = NumGrains;
            this.DoloPercent = DoloPercent;
            this.StartTime = clock;
            this.Steps = Step.empty;
        end
    end
end

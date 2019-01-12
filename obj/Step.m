classdef Step
    properties
        StepId
        ChunckEvents
        Mechanical_Dissolution
        Chemical_Dissolution
    end
    methods
        function this=Step(StepId)
            this.StepId = StepId;
            this.ChunckEvents = ChunckEvent.empty;
        end
    end
end
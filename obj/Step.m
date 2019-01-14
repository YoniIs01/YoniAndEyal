classdef Step
    properties
        StepId
        ChunckEvents
        Mechanical_Dissolution
        Chemical_Dissolution
        SolutionContactArea
        SolutionContactLinearIndex
    end
    properties (Dependent)
        EventsNumber
    end
    methods
        function value = get.EventsNumber(this)
            value = length(this.ChunckEvents);
        end
        function value = get.SolutionContactArea(this)
            value = length(this.SolutionContactLinearIndex);
        end
        function this=Step(StepId)
            this.StepId = StepId;
            this.ChunckEvents = ChunckEvent.empty;
        end
    end
end
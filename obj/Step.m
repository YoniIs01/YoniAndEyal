classdef Step
    properties
        StepId
        ChunckEvents
        Mechanical_Dissolution
        Chemical_Dissolution
        SolutionContactLinearIndex
    end
    properties (Dependent)
        EventsNumber
        BigEventsNumber
        TotalDissolution
        SolutionContactArea
        MaxChunkSize
    end
    methods
        function value = get.EventsNumber(this)
            value = length(this.ChunckEvents);
        end
        function value = get.BigEventsNumber(this)
            e = this.ChunckEvents;
            if isempty(e)
                value = 0;
            else
                value = length(e([e.Area]>10));
            end
        end
        
        function value = get.TotalDissolution(this)
            value = this.Chemical_Dissolution + this.Mechanical_Dissolution;
        end
        function value = get.SolutionContactArea(this)
            value = length(this.SolutionContactLinearIndex);
        end
        function value = get.MaxChunkSize(this)
            if this.EventsNumber == 0 
                value = 0;
            else
                value = max([this.ChunckEvents.Area]);
            end
        end
        
        function this=Step(StepId) %constructor
            this.StepId = StepId;
            this.ChunckEvents = ChunckEvent.empty;
        end
    end
end
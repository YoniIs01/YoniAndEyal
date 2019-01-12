classdef ChunckEvent
    properties
        Area
        Width
        Height
        Dimension
    end
    methods
        function obj=ChunckEvent(Event)
            obj.Area = Event.Area;
            obj.Width = Event.MajorAxisLength;
            obj.Height = Event.MinorAxisLength;
            obj.Dimension = ceil(obj.Width*obj.Height);
        end
    end
end
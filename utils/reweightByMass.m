function [ReweightedData] = reweightByMass(GrainAreas)
%REWEIGHTBYMASS Summary of this function goes here
%   Detailed explanation goes here
    ReweightedData = [];
    for area = GrainAreas
        ReweightedData = [ReweightedData area*ones(1,area)];
    end
end


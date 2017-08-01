function [ downsampled_data ] = ReduceDataset(data, keep_of_five)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    numSamples = size(data, 2);
    downsampled_data = zeros(size(data, 1), ceil(numSamples * keep_of_five / 5));
    
    count = 0;
    for i=1:numSamples
        if mod(i, 5) < keep_of_five
            count = count + 1;
            downsampled_data(:, count) = data(:, i);
        end
    end
end


function [ files_data ] = ReadValidationFiles( folder )
%READVALIDATIONFILES Summary of this function goes here
%   Detailed explanation goes here

    % DEFINE THE VALIDATION FOLDER TO BE USED
    files = [dir([folder,'*_Left.txt'])';
             dir([folder,'*_Right.txt'])'];
    
    % Get number of data entries. Number of left and right files should be the
    % same
    num_files = size(files, 2);
    files_data = cell(num_files, 2);
    % Get files contents for both right and left hands in a cell array
    for i=1:1:num_files
        for hand_index=1:1:2
            current_file = fopen([folder files(hand_index, i).name],'r');
            files_data{i, hand_index} = fscanf(current_file,'a;%ld;%f;%f;%f\n',[4,inf]);
        end
    end
end


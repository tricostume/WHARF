function [ x_set y_set z_set numSamples ] = GetProcessedData( modelfile,hand_index )
%GETPROCESSEDDATA Summary of this function goes here

% This function is used to extract the data in the matrix form from the
% preprocessed data mat files. 
% Input arguments: 
%   modelfile --> the mat file containing the data of the model in consideration
%   hand_index --> parameter defining which the hand in consideration
%   (left==1/right==2)
% Outpt arguments:
%   x_set --> acceleration values measured along the x axis in each file
%             at each given time instant (each column corresponds to the
%             x axis of a file)
%   y_set --> acceleration values measured along the y axis in each file
%             at each given time instant (each column corresponds to the
%             y axis of a file)
%   z_set --> acceleration values measured along the z axis in each file
%             at each given time instant (each column corresponds to the
%             z axis of a file)
%   numSamples --> number of sample points measured by the accelerometer in
%                  each file (number of rows in the files, that must be
%                  same for ALL files)

    %Loading the mat  file
    prdata=matfile(modelfile);
    %Extracting the data
    numSamples=prdata.numSamples;
    if(hand_index==1)
       x_set=prdata.processed_data.left.x';
       y_set=prdata.processed_data.left.y';
       z_set=prdata.processed_data.left.z';
    elseif(hand_index==2)
       x_set=prdata.processed_data.right.x';
       y_set=prdata.processed_data.right.y';
       z_set=prdata.processed_data.right.z';
    else
       disp('Invalid Hand Index');
    end

end
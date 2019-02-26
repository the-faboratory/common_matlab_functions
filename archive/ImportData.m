function [ cellArray ] = importData( files, folder, format, numberOfColumns, numberOfHeaders )
% IMPORTDATA Import data from a file. Typically used with Instron Data.
% Note: Any empty cells in .csv should be filled with dummy value. Ex:
% cycle count units usually is empty. Fill it with x, for instance.
%   [ cellArray ] = IMPORTDATA( files, folder, format, numcol, numhead )
%   Imports data from FILES located in FOLDER, with format FORMAT.
%
%   Required Inputs: 
%   FILES - the files to be imported.
%   FOLDER - folder containing the files.
%   FORMAT - format of the data. Ex.: %f%f%f for floating point.
%   NUMBEROFCOLUMNS - number of columns for each row.
%   NUMBEROFHEADERS - number of rows that are headers.
%
%   Optional inputs  (positional):
%   N/A
%   Optional Parameters (not positional, specified by an identifying string):
%   N/A%
%
%   Outputs:
%   CELLARRAY - an array of cells which contain your data.

%   Notes: Typical Column Headers - [Time Extension Load Voltage Strain Stress]

% Initialize output cell array
cellArray = cell(size(files,1), 1);
for i = 1:size(files, 2)
    filename = fopen([folder files{i} '.csv']);
    temporaryCellArray = textscan(filename, format, 'headerlines', numberOfHeaders);
    newFormat = zeros(length(temporaryCellArray{1}), numberOfColumns); % initialize each cell of cellArray w/ proper format
    for j = 1:numberOfColumns
        newFormat(:,j) = temporaryCellArray{j};
    end
    cellArray{i} = newFormat;
end


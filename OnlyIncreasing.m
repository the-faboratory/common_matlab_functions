function [ increasingCell ] = onlyIncreasing( cellArrayOfData, column, skipFirst )
% OnlyIncreasing remove decreasing data points.
%   Remove decreasing data points (rows of data) of [cellArrayOfData],
%   according to whether data in column were decreasing[xDataColumn]. No
%   optional arguments available.
%
% Required inputs:
% CELLARRAYOFDATA = cell array with the input data.
% XDATACOLUMN = column to be examined for increasing between rows.
% SKIPFIRST = whether or not to skip the first row of data.
% 
% TODO:
% 1. (Low priority) Check whether cellArray is a cell or an array. Act
% accordingly. Related: maybe temp is unnecessary
% 2. (Low priority) 

validRow = 1;
arrayOfData = cellArrayOfData{1,1};
increasingArray(1,:) = arrayOfData(1,:);
first = true; % Don't add first monotonically increasing data chunk if skipFirst flag is set

for row = 2: size(arrayOfData,1)
    
    if arrayOfData(row, column) > arrayOfData(row-1, column) && ~(skipFirst && first)
        increasingArray(validRow, :) = arrayOfData(row, :);
        validRow = validRow + 1;
        
    % (Don't add first monotonically increasing data chunk if skipFirst
    % flag is set)
    elseif arrayOfData(row, column) < arrayOfData(row-1, column)
        first = false;
    end
end
increasingCell = {increasingArray};
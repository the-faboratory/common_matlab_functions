function [ increasingArray ] = onlyIncreasing( arrayOfData, xDataColumn, varargin )
% ONLYINCREASING remove decreasing data points.
%   [ increasingCell ] = ONLYINCREASING( cellArrayOfData, column, skipFirst
%   ) Remove decreasing data points (rows of data) of [cellArrayOfData],
%   according to whether data in column [xDataColumn] were decreasing.
%
%   Required inputs:
%   CELLARRAYOFDATA = cell array with the input data.
%   XDATACOLUMN = column to be examined for increasing between rows.
%
%   Optional inputs  (positional):
%   N/A
%
%   Optional Parameters (not positional, specified by an identifying string):
%   SKIPFIRST = whether or not to skip the first monotonically increasing
%   (strain) data chunk.

% TODO:
% 1. (Low priority) Check whether cellArray is a cell or an array. Act
% accordingly. Related: maybe temp is unnecessary
% 2. (Low priority) Expand to allow multiple cell and/or array inputs

% Function parser described here https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
% In brief: add[type](inputParser,name,check function)
p = inputParser;
addRequired(p, 'arrayOfData', @isnumeric)
addRequired(p, 'xDataColumn', @isnumeric)
addParameter(p, 'skipFirst', false, @islogical)
addParameter(p, 'onlyFirstCycle', false, @islogical)

parse(p, arrayOfData, xDataColumn, varargin{:})

validRow = 1;
increasingArray(1, :) = arrayOfData(1, :);
first = true; % Don't add first monotonically increasing data chunk if skipFirst flag is set

for row = 2: size(arrayOfData,1)
    
    if arrayOfData(row, xDataColumn) > arrayOfData(row-1, xDataColumn) && ~(p.Results.skipFirst && first)
        increasingArray(validRow, :) = arrayOfData(row, :);
        validRow = validRow + 1;
        
        % (Don't add first monotonically increasing data chunk if skipFirst
        % flag is set)
    elseif arrayOfData(row, xDataColumn) < arrayOfData(row-1, xDataColumn)
        first = false;
    elseif arrayOfData(row, xDataColumn) < arrayOfData(row-1, xDataColumn) && p.Results.onlyFirstCycle
        break; % Stop once we are decreasing
    end
end

function [ aboveArray ] = aboveValue( arrayOfData, xDataColumn, minimumXValue, varargin )
% aboveValue remove decreasing data points.
%   [ aboveCell ] = aboveValue( cellArrayOfData, column, skipFirst
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
addRequired(p, 'minimumXValue', @isnumeric)
addParameter(p, 'truncateWithNaNs', false, @islogical)

parse(p, arrayOfData, xDataColumn, minimumXValue, varargin{:})

validRow = 1;
aboveArray = zeros(size(arrayOfData));

for row = 1: size(arrayOfData,1)
    
    if arrayOfData(row, xDataColumn) > minimumXValue
        aboveArray(validRow, :) = arrayOfData(row, :);
        validRow = validRow + 1;
    end
end

if p.Results.truncateWithNaNs
    aboveArray(aboveArray == 0) = nan;
end

% aboveArray( ~any(aboveArray,2), : ) = [];  % delete zero rows. Not needed
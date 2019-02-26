function [ aboveArray ] = aboveValue( arrayOfData, xDataColumn, minimumXValue, varargin )
% aboveValue remove decreasing data points.
%   [ aboveArray ] = aboveValue( arrayOfData, xDataColumn, minimumXValue, varargin
%   ) Remove decreasing data points (rows of data) of [arrayOfData],
%   according to whether data in column [xDataColumn] were decreasing. Useful for removing
%   return-to-zero curves on strain tests
%
%   Required inputs:
%   arrayOfData = array with the input data.
%   xDataColumn = column to be examined for increasing between rows.
%   minimumXValue = minimum acceptable x value (typically 0)
%
%   Optional inputs  (positional):
%   N/A
%
%   Optional Parameters (not positional, specified by an identifying string):
%   truncateWithNaNs = Replace zero rows with NaN. I don't know why this was added

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

% aboveArray( ~any(aboveArray,2), : ) = [];  % delete zero rows. Optional

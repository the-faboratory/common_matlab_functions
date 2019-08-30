function [ increasing_array ] = only_increasing( array_of_data, x_data_column, varargin )
% only_increasing: remove decreasing data points.
%   [ increasing_array ] = only_increasing( cellArrayOfData, column, skip_first
%   ) Remove decreasing data points (rows of data) of [cellArrayOfData],
%   according to whether data in column [x_data_column] were decreasing.
%
%   Required inputs:
%   array_of_data = cell array with the input data.
%   x_data_column = column to be examined for increasing between rows.
%
%   Optional inputs  (positional):
%   N/A
%
%   Optional Parameters (not positional, specified by an identifying string):
%   skip_first = whether or not to skip the first monotonically increasing
%   (strain) data chunk.
%   only_first_cycle = whether or not to only output the first cycle of data

% TODO:
% 1. (Low priority) Check whether cellArray is a cell or an array. Act
% accordingly. Related: maybe temp is unnecessary
% 2. (Low priority) Expand to allow multiple cell and/or array inputs

% Function parser described here https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
% In brief: add[type](inputParser,name,check function)
p = inputParser;
addRequired(p, 'array_of_data', @isnumeric)
addRequired(p, 'x_data_column', @isnumeric)
addParameter(p, 'skip_first', false, @islogical)
addParameter(p, 'only_first_cycle', false, @islogical)

parse(p, array_of_data, x_data_column, varargin{:})

number_of_valid_rows = 1;
increasing_array(1, :) = array_of_data(1, :);
first_chunk = true; % Don't add first monotonically increasing data chunk if skip_first flag is set

for row = 2: size(array_of_data,1)
    
    if array_of_data(row, x_data_column) > array_of_data(row-1, x_data_column) && ~(p.Results.skip_first && first_chunk)
        increasing_array(number_of_valid_rows, :) = array_of_data(row, :);
        number_of_valid_rows = number_of_valid_rows + 1;
        
        % (Don't add first monotonically increasing data chunk if skip_first
        % flag is set)
    elseif array_of_data(row, x_data_column) < array_of_data(row-1, x_data_column)
        first_chunk = false;
    elseif array_of_data(row, x_data_column) < array_of_data(row-1, x_data_column) && p.Results.only_first_cycle
        break; % Stop once we are decreasing
    end
end

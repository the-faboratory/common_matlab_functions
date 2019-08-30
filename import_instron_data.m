function [ data_cells ] = import_instron_data( folder, file_prefix, file_suffixes, varargin )
% import_instron_data: import instron data
%   [ increasing_array ] = import_instron_data( cellArrayOfData, column, skip_first
%   ) Import data files located in a given folder, with a filename pattern of
%   "[file_prefix][file_suffix].csv"
%
%   Required inputs:
%   array_of_data = cell array with the input data.
%   x_data_column = column to be examined for increasing between rows.
%
%   Optional inputs  (positional):
%   N/A
%
%   Optional Parameters (not positional, specified by an identifying string):
%   N/A

% TODO:
% N/A

% Function parser described here https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
% In brief: add[type](inputParser, name, check function)
p = inputParser;
addRequired(p, 'folder', @ischar)
addRequired(p, 'file_prefix', @ischar)
addRequired(p, 'file_suffixes', @ischar)
% addParameter(p, 'skip_first', false, @islogical)

data_cells = cell(length(file_suffixes), 1);
cell_index = 1;
for file = file_suffixes
    data_cells{cell_index}(:, :) = xlsread([folder file_prefix int2str(file) '.csv']);
    cell_index = cell_index + 1;
end
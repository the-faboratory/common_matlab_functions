function [ line ] = plotClouds( in_cell_array_of_data, x_column, y_column, lower_bound_x, bin_width_x, upper_bound_x, varargin )
% DATAANALYSIS Plot clouds (confidence intervals.)
%   [ line ] = PLOTCLOUDS(
%   in_cell_array_of_data, xCol, yCol, lower_bound_x, bin_width_x, upper_bound_x ) generates
%   information for the patches that can be plotted as clouds. Warning: will truncate negative response
%   (sensor, stress, etc.) confidence values to 0.01
%
%   Required Inputs:
%   in_cell_array_of_data = cell array with your data,
%   xCol, yCol = column number containing x,y data,
%   lower_bound_x = Lower bound of your x data
%   bin_width_x = width of each bin
%   upper_bound_x = upper bound of your x data
%
%   Optional inputs:
%   initialRow = first row that you want plotted. Deafult = 1
%   pValue = what percent of the data lies to the right of your confidence
%   interval's left bound. Ex.: 95% CI has pValue = 0.975. Default = 0.975
%   subtractInitial = should we subtract the initial value for a given
%   column from all data in that column? Default = FALSE
%   cloudsFirst = plot clouds before plotting the mean. Default = TRUE
%   showCloudInLegend = should we show the cloud in the legend (calling
%   function/script must create the legend). Default = FALSE
% 
%   Outputs:
%   line = the line which was just plotted


%% Parse Inputs
% Function parser described here https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
% In brief: add[type](inputParser,name,check function)
p = inputParser;
addRequired(p, 'in_cell_array_of_data', @iscell)
addRequired(p, 'x_column', @isnumeric)
addRequired(p, 'y_column', @isnumeric)
addRequired(p, 'lower_bound_x', @isnumeric)
addRequired(p, 'bin_width_x', @isnumeric)
addRequired(p, 'upper_bound_x', @isnumeric)
addOptional(p, 'pValue', 0.975, @isnumeric)
addOptional(p, 'initialRow', 1, @isnumeric)
addOptional(p, 'subtractInitial', true, @islogical)
addOptional(p, 'cloudsFirst', true, @islogical)
addOptional(p, 'showCloudInLegend', false, @islogical)
addOptional(p, 'plotClouds', true, @islogical)


default_color = false; % If color not specified, let MATLAB decide a default color
is_char_or_numeric = @(x) ischar(x) + isnumeric(x);
addParameter(p, 'color', default_color, is_char_or_numeric)
addParameter(p, 'style', '-', @ischar)
addParameter(p, 'yConstant', 1, @isnumeric)

parse(p, in_cell_array_of_data, x_column, y_column, lower_bound_x, bin_width_x, upper_bound_x, varargin{:})

%% Sort by each sensor's data by xCol

number_of_cells = size(in_cell_array_of_data,2); % Number of cells
number_of_columns = size(in_cell_array_of_data{1},2); % Number of columns
all_data = zeros(0,number_of_columns);   % initialize AllData array
% Concatenate data
for i = 1:1
    all_data = vertcat(all_data, in_cell_array_of_data{i}(:,:));      % concatenate each sensor i
end
all_data_sorted = sortrows(all_data, x_column); % sort data 
y_data_first_cell = in_cell_array_of_data{1}(:,y_column);

%% Bin x and y for all sensors

bin_edges = lower_bound_x:bin_width_x:upper_bound_x;   % Define bins
number_of_bins = length(bin_edges);
binned_data = cell(number_of_bins, 1);    % Initialize cell array for the bins
k = 1; % which row in binned_data to add next row to
b = 0; % which bin you're at
% Loop over all bins
for row = 1:size(all_data_sorted, 1)
    temp_row = all_data_sorted(row, :);
    if b<length(bin_edges)           % Bin the data from bins (1,numBins-1)
        if temp_row(x_column)>bin_edges(b + 1) % If current xCol value is greater than next binEdge
            k = 1; % Restart count
            b = b + 1;
        end
    end
    binned_data{b}(k, :) = temp_row; % Add this row to the current bin
    k = k + 1;
end


%% Find mean and standard deviation for each bin
bin_statistics = zeros(0, 3); % initialize matrix for meanF, stdevF, CIF. length = number of bins
number_of_bins_minus_one = number_of_bins - 1;
bin_means = zeros(1, number_of_bins_minus_one); % initialize other arrays
bin_count = zeros(1, number_of_bins);
number_of_valid_rows = 1; % counter for how many valid (containing more than 3 data points) rows we have

for b = 1:number_of_bins_minus_one
    bin_count(b) = size(binned_data{b}, 1);
    
    % If the bin is nearly empty, move on to next bin
    if bin_count(b) < 3
        continue % Skip rest of current cycle of this for loop
    end
    
    % If the bin has valid elements, then compute statistics
    bin_statistics(number_of_valid_rows, 1) = mean(binned_data{b}(:, y_column));
    bin_statistics(number_of_valid_rows, 2) = std(binned_data{b}(:, y_column));
    t_statistic = tinv(p.Results.pValue,bin_count(b)-1); % 95% CI t-statistic
    %     t_statistic = 2.26; % 95% CI t-statistic % HARDCODED
    bin_statistics(number_of_valid_rows,3) = t_statistic*bin_statistics(number_of_valid_rows,2);   % 95%CI
    bin_means(number_of_valid_rows) = mean(binned_data{b}(:, x_column));
    number_of_valid_rows = number_of_valid_rows + 1;
end
% meanBinCount = mean(bin_count); % Print mean number of elements in the bins, for debugging
bin_means = bin_means(1:number_of_valid_rows - 1); % Extract valid means. We incremented number_of_valid_rows one too many times (see loop)

%% Plot Mechanical Response
% Generate the cloud's outline
cloud_bounds(1, :) = bin_statistics(:, 1) + bin_statistics(:, 3); % mean + 95% CI
cloud_bounds(2, :) = bin_statistics(:, 1) - bin_statistics(:, 3); % mean - 95% CI
[x_patches, y_patches] = get_patches(cloud_bounds(1, :),cloud_bounds(2, :),bin_means);

x_patches(x_patches<0) = 0.01; % Dyl Important! Negative stress or force makes no sense for most of our datasets
y_patches(y_patches<0) = 0.01; % Dyl Important! Negative stress or force makes no sense for most of our datasets

% Optionally subtract initial value
if(p.Results.subtractInitial)
    y_patches = y_patches - y_data_first_cell(p.Results.initialRow);
    bin_statistics(:, 1) = bin_statistics(:, 1) - y_data_first_cell(p.Results.initialRow);
end

% Plot
if (p.Results.plotClouds) % Optionally plot cloud
    % Plot Clouds
    if p.Results.cloudsFirst
        cloud = patch(x_patches, p.Results.yConstant*(y_patches), p.Results.color, 'FaceAlpha', 0.35, 'edgeColor', 'none');
        line = plot(bin_means, p.Results.yConstant*(bin_statistics(:, 1)), '--', 'Color', p.Results.color, 'LineWidth', 2.0, 'DisplayName', 'Mean');
    else
        line = plot(bin_means, p.Results.yConstant*(bin_statistics(:, 1)), '--', 'Color', p.Results.color, 'LineWidth', 2.0, 'DisplayName', 'Mean');
        cloud = patch(x_patches, p.Results.yConstant*(y_patches), p.Results.color, 'FaceAlpha', 0.35, 'edgeColor', 'none');
    end

    % Hide the cloud color in legend, if we don't want to show it
    if ~p.Results.showCloudInLegend
        set(get(get(cloud,'Annotation'),'LegendInformation'),...
            'IconDisplayStyle','off'); % Exclude cloud from legend
    end
else % Just plot mean
    line = plot(bin_means, p.Results.yConstant*(bin_statistics(:, 1)), '--', 'Color', p.Results.color, 'LineWidth', 2.0, 'DisplayName', 'Mean');
end

end

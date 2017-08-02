function [  ] = plotClouds( cellArrayOfData, xColumn, yColumn, inBinLower, binInc, inBinUpper, varargin )
% DATAANALYSIS Plot clouds (confidence intervals.)
%   [ ] = PLOTCLOUDS(
%   cellArrayOfData, xCol, yCol, inBinLower, binInc, inBinUpper ) generates
%   information for the patches that can be plotted as clouds.
%
%   Required Inputs:
%   cellArrayOfData- cell array with your data,
%   xCol, yCol - colum number containing x,y data,
%   inBinLower - Lower bound of your x data
%   binInc - width of each bin
%   inBinUpper - upper bound of your x data
%
%   Optional inputs:
%   initialRow - first row that you want plotted. Deafult = 1
%   subtractInitial - should we subtract the initial value for a given
%   column from all data in that column? Default = FALSE
%   cloudsFirst - plot clouds before plotting the mean. Default = TRUE
%   showCloudInLegend - should we show the cloud in the legend (calling
%   function/script must create the legend). Default = FALSE
% 
%   Outputs:

%   Original source code written by Edward White. Significantly modified by
%   Dylan Shah, most recently on 2017-05-29 YMD.


%% Parse Inputs
% Function parser described here https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
% In brief: add[type](inputParser,name,check function)
p = inputParser;
addRequired(p, 'cellArrayOfData', @iscell)
addRequired(p, 'xColumn', @isnumeric)
addRequired(p, 'yColumn', @isnumeric)
addRequired(p, 'inBinLower', @isnumeric)
addRequired(p, 'binInc', @isnumeric)
addRequired(p, 'inBinUpper', @isnumeric)
addOptional(p, 'initialRow', 1, @isnumeric)
addOptional(p, 'subtractInitial', true, @islogical)
addOptional(p, 'cloudsFirst', true, @islogical)
addOptional(p, 'showCloudInLegend', false, @islogical)

defaultColor = false; % If color not specified, let MATLAB decide a default color
isCharOrNumeric = @(x) ischar(x) + isnumeric(x);
addParameter(p, 'color', defaultColor, isCharOrNumeric)
addParameter(p, 'style', '-', @ischar)
addParameter(p, 'yConstant', 1, @isnumeric)

parse(p, cellArrayOfData, xColumn, yColumn, inBinLower, binInc, inBinUpper, varargin{:})

%% Sort by each sensor's data by xCol

% Ignore unless you want to plot multiple specimens
% AllDataF = zeros(0,6);   % initialize AllData array
% for i = 1:1
%     AllDataF = vertcat(AllDataF, celeryF{i}(:,:));      % concatenate each sensor i
% end
%AllDataSortF = sortrows(AllDataF,5); % sort by Extension2

allDataSortF = sortrows(cellArrayOfData{1}(:,:), xColumn); % sort by xCol
sensorData = cellArrayOfData{1}(:,yColumn);

%% Bin x and y for all sensors

binEdges = inBinLower:binInc:inBinUpper;   % Define bins
nBins = length(binEdges); % Print bins
binsOfData = cell(nBins, 1);    % Initialize cell array for the Bins
k = 1; % counter for which row in BinsF to add next row to
b = 0; % counter for which bin you're at

for row = 1:size(allDataSortF, 1)
    tempRow = allDataSortF(row, :);
    if b<length(binEdges)           % Bin the data from bins (1,numBins-1)
        if tempRow(xColumn)>binEdges(b + 1) % If current xCol value is greater than next binEdge
            k = 1; %Restart count
            b = b + 1;
        end
    end
    binsOfData{b}(k, :) = tempRow; % Add this row to the current bin
    k = k + 1; % increment
end


%% Find mean and stdev for each Bin
binStatistics = zeros(0, 3); % initialize matrix for meanF, stdevF, CIF. length = number of bins
nBinsM1 = nBins - 1;
binMeans = zeros(1, nBinsM1); % initialize other arrays
binCount = zeros(1, nBins);
validRow = 1; % counter for how many valid (containing more than 3 data points) rows we have

for b = 1:nBinsM1
    binCount(b) = size(binsOfData{b}, 1);
    
    % If the bin is nearly empty, move on to next bin
    if binCount(b) < 3
        continue % Skip rest of current cycle of this for loop
    end
    
    % If the bin has valid elements, then compute statistics
    binStatistics(validRow, 1) = mean(binsOfData{b}(:, yColumn));
    binStatistics(validRow, 2) = std(binsOfData{b}(:, yColumn));
    tStatistic = tinv(0.975,binCount(b)-1); % 95%CI t-statistic
    %     tStatistic = 2.26; % 95%CI t-statistic % HARDCODED
    binStatistics(validRow,3) = tStatistic*binStatistics(validRow,2);   % 95%CI
    binMeans(validRow) = mean(binsOfData{b}(:, xColumn));
    validRow = validRow + 1;
end
meanBinCount = mean(binCount); % Print mean number of elements in the bins. Keep for debugging
binMeans = binMeans(1:validRow - 1); % (Implementation note: validRow starts at 1, and is incremented by one every time.)


%% Plot Mechanical Response
% Generate the cloud's outline
boundsF(1, :) = binStatistics(:, 1) + binStatistics(:, 3); % mean+95%CI
boundsF(2, :) = binStatistics(:, 1) - binStatistics(:, 3); % mean-95%CI
[xPatches, yPatches] = getPatches(boundsF(1, :),boundsF(2, :),binMeans);

% Plot the cloud
% offsetPlotClouds = sensorData(p.Results.initialRow) % For debugging
if(p.Results.subtractInitial)
    yPatches = yPatches - sensorData(p.Results.initialRow);
    binStatistics(:, 1) = binStatistics(:, 1) - sensorData(p.Results.initialRow);
    %     patch(xPatches, p.Results.yConstant*(yPatches - sensorData(p.Results.initialRow)), p.Results.color, 'FaceAlpha', 0.35, 'edgeColor', 'none');
    %     plot(binMeans, p.Results.yConstant*(binStatistics(:, 1) - sensorData(p.Results.initialRow)), '--', 'Color', p.Results.color, 'LineWidth', 2.0, 'DisplayName', 'Mean');
else
    % Do Nothing
end

if p.Results.cloudsFirst
    cloud = patch(xPatches, p.Results.yConstant*(yPatches), p.Results.color, 'FaceAlpha', 0.35, 'edgeColor', 'none');
    line = plot(binMeans, p.Results.yConstant*(binStatistics(:, 1)), '--', 'Color', p.Results.color, 'LineWidth', 2.0, 'DisplayName', 'Mean');
else
    line = plot(binMeans, p.Results.yConstant*(binStatistics(:, 1)), '--', 'Color', p.Results.color, 'LineWidth', 2.0, 'DisplayName', 'Mean');
    cloud = patch(xPatches, p.Results.yConstant*(yPatches), p.Results.color, 'FaceAlpha', 0.35, 'edgeColor', 'none');
end
if ~p.Results.showCloudInLegend
    set(get(get(cloud,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off'); % Exclude line from legend
end
end


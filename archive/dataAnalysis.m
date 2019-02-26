function [ xPatches, yPatches, binMeans, binStatistics ] = dataAnalysis( cellArrayOfData, xCol, yCol, inBinLower, binInc, inBinUpper )
% DATAANALYSIS Generate information for plotting clouds (confidence
% intervals.)
%   [ xPatches, yPatches, binMeans, binStatistics ] = DATAANALYSIS(
%   cellArrayOfData, xCol, yCol, inBinLower, binInc, inBinUpper ) generates
%   information for the patches that can be plotted as clouds.

%   Required Inputs: 
%   cellArrayOfData- cell array with your data,
%   xCol, yCol - colum number containing x,y data, 
%   inBinLower - Lower bound of your x data
%   binInc - width of each bin
%   inBinUpper - upper bound of your x data
%
%   Optional inputs:
%
%   Outputs:
%   xPatches, yPatches - complete coordinates for your cloud.
%   binMeans - monotonically-increasing x-values for your cloud (means of
%   actual points in the bins, rather than the mean of the bin)
%   binStatistics - statistics for your coordinates (mean, standard
%   deviation, 95% confidence interval.

%   Original source code written by Edward White. Significantly modified by
%   Dylan Shah, most recently on 2017-05-29 YMD.

%% Sort by each sensor's data by xCol

% Ignore unless you want to plot multiple specimens
% AllDataF = zeros(0,6);   % initialize AllData array
% for i = 1:1
%     AllDataF = vertcat(AllDataF, celeryF{i}(:,:));      % concatenate each sensor i
% end
%AllDataSortF = sortrows(AllDataF,5); % sort by Extension2

allDataSortF = sortrows(cellArrayOfData{1}(:,:), xCol); % sort by xCol


%% Bin x and y for all sensors

binEdges = inBinLower:binInc:inBinUpper;   % Define bins
nBins = length(binEdges); % Print bins
binsOfData = cell(nBins, 1);    % Initialize cell array for the Bins 
k = 1; % counter for which row in BinsF to add next row to
b = 0; % counter for which bin you're at

for row = 1:size(allDataSortF, 1)
    tempRow = allDataSortF(row, :);
    if b<length(binEdges)           % Bin the data from bins (1,numBins-1)
        if tempRow(xCol)>binEdges(b + 1) % If current xCol value is greater than next binEdge
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
   binStatistics(validRow, 1) = mean(binsOfData{b}(:, yCol));
   binStatistics(validRow, 2) = std(binsOfData{b}(:, yCol));
%    FF(b,3) = tinv(0.975,binCount-1)*FF(b,2);   % 95%CI
    binStatistics(validRow, 3) = 2.26*binStatistics(validRow, 2);   % 95%CI % HARDCODED
   binMeans(validRow) = mean(binsOfData{b}(:, xCol));
   validRow = validRow + 1;
end
meanBinCount = mean(binCount) % Print mean number of elements in the bins
binMeans = binMeans(1:validRow - 1); % (Implementation note: validRow starts at 1, and is incremented by one every time.)


%% Plot Mechanical Response
%Create the cloud
boundsF(1, :) = binStatistics(:, 1) + binStatistics(:, 3); % mean+95%CI
boundsF(2, :) = binStatistics(:, 1) - binStatistics(:, 3); % mean-95%CI
[xPatches, yPatches] = getPatches(boundsF(1, :),boundsF(2, :),binMeans);


end

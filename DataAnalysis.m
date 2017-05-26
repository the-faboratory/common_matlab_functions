function [ x,y,dxF,statisticsF ] = DataAnalysis( celeryF, nF, xCol, yCol, inBinLower, binInc, inBinUpper )
% Output information for plotting clouds. 
% Input: celeryF- cell array with your data, nF- Number of samples (rows),
% xCol, yCol - colum number containing x,y data, inBinLower- Lower bound of
% your bins, binInc- width of each bin, inBinUpper- upper bound of your bins


%% Sort by each sensor's data by dx=extension2

% Ignore unless you want to plot multiple specimens
% AllDataF = zeros(0,6);   % initialize AllData array
% for i = 1:1
%     AllDataF = vertcat(AllDataF, celeryF{i}(:,:));      % concatenate each sensor i
% end
%AllDataSortF = sortrows(AllDataF,5); % sort by Extension2

allDataSortF = sortrows(celeryF{1}(:,:),xCol); % sort by xCol

%% Bin F and dV for all sensors

binEdges = inBinLower:binInc:inBinUpper;   % Define bins
nBins = length(binEdges); % Print bins
BinsF = cell(nBins,1);    % Initialize cell array for the Bins 
k = 1; % counter for which row in BinsF to add next row to
b = 0; % counter for which bin you're at

for row = 1:size(allDataSortF,1)
    tempRow = allDataSortF(row,:);
    if b<length(binEdges)           % Bin the data from bins (1,numBins-1)
        if tempRow(xCol)>binEdges(b+1) % If current xCol value is greater than next binEdge
            k = 1; %Restart count
            b = b+1;
        end        
    end
    BinsF{b}(k,:) = tempRow; % Add this row to the current bin
    k = k+1; % increment 
end

%% Find mean and stdev for each Bin
statisticsF = zeros(0,3); % initialize matrix for meanF, stdevF, CIF. length = number of bins
nBinsM1 = nBins-1;
dxF = zeros(1,nBinsM1);
binCount = zeros(1,nBins);
validRow = 1;

for b = 1:nBinsM1
   binCount(b) = size(BinsF{b},1);
   
   % If the bin is nearly empty, move on to next bin
   if binCount(b) < 3
       continue % Skip rest of current cycle of this for loop
   end
   
   % If the bin has valid elements, then compute statistics
   statisticsF(validRow,1) = mean(BinsF{b}(:,yCol));
   statisticsF(validRow,2) = std(BinsF{b}(:,yCol));
%    FF(b,3) = tinv(0.975,binCount-1)*FF(b,2);   % 95%CI
    statisticsF(validRow,3) = 2.26*statisticsF(validRow,2);   % 95%CI % HARDCODED
   dxF(validRow) = mean(BinsF{b}(:,xCol));
   validRow = validRow + 1;
end
meanBinCount = mean(binCount) % Print mean number of elements in the bins
dxF = dxF(1:validRow-1); % (Implementation note: validRow starts at 1, and is incremented by one every time.)

%% Plot Mechanical Response
%Create the cloud
boundsF(1,:) = statisticsF(:,1)+statisticsF(:,3); % mean+95%CI
boundsF(2,:) = statisticsF(:,1)-statisticsF(:,3); % mean-95%CI
[x,y] = getPatches(boundsF(1,:),boundsF(2,:),dxF);

end

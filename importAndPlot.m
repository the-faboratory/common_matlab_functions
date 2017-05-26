function [ data expFilteredData ] = importAndPlot( folder, sensLength, expConst, xMin, xMax )
%IMPORTANDPLOT import data from an excel file and plot that data.
%   Note: As of 2017-5-10, this hard-coded excel reading range, and several
%   plot parameters. UNFINISHED.
%   This script graphs data columns against an "x" column, such as time.
%   Can export an exponentially filtered version of data columns.
%
%   Required Inputs:
%   

%% Import Data
data = importFromArduino(folder, sprintf('Analog_50HzRestingOnTube_%scm.xlsx',sensLength),1,2,5000,'A','E');
expFilteredData = expFilter(data, expConst);

%% Plot
xMin = 0*1000; % Minimum time, in milliseconds
xMax = 20*1000; % Maximum time, in milliseconds
yBandLimit = 0.25;
% Colors and type (format) for plotting
S1 = [208,28,139]/255;
S2 = [241,182,218]/255;
S3 = [184,225,134]/255;
S4 = [77,172,38]/255;
unfilteredColors = [S1; S2; S3; S4];
unfilteredType = '-';
filteredColors = [S1; S2; S3; S4]/2;
filteredType = '--';

% Plot T1 data while bending
meanS1 = mean(expFilteredData(:,1));
plotAllCols(data,5,true,unfilteredColors,unfilteredType);
plotAllCols(expFilteredData,5,true,filteredColors,filteredType);
ylim([-meanS1*yBandLimit, meanS1*yBandLimit]);

end


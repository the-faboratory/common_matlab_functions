function [ result ] = plotAllCols( inArray, xDataColumn, varargin )
% plotAllCols Plot all columns of data
%   Plot all columns of [inArray], with the x column specified by
%   [xDataColumn]. Optional arguments available through varargin.
%
% Required inputs:
% INARRAY = data to be plotted
% XDATACOLUMN = column to be used as x-coordinate for plotting
%
% Optional inputs (positional):
% SUBTRACTMEAN = subtract mean from data prior to plotting
%
% Optional Parameters (not positional, specified by an identifying string):
% COLORS = what colors to plot with. Row in an array (char, or 1x3 numeric
% for each column
% STYLE = style of symbol you want plotted. Ex: '-' for line, '--' broken
% line

% Function parser described here https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html
% In brief: add[type](inputParser,name,check function)
p = inputParser;
addRequired(p,'inArray',@isnumeric)
addRequired(p,'xDataColumn',@isnumeric)
addOptional(p,'subtractMean',true,@islogical)

% If we know there are four sensor reading columns, assign default colors
if size(inArray,2) == 5
    defaultColors = ['r';'g';'b';'k'];
else
    defaultColors = false; % Else, let MATLAB decide a default color
end
isCharOrNumeric = @(x) ischar(x) + isnumeric(x);
addParameter(p,'colors',defaultColors,isCharOrNumeric)
addParameter(p,'style','-',@ischar)

parse(p,inArray, xDataColumn, varargin{:})

hold on
% Subtract mean
if p.Results.subtractMean
    time = inArray(:,xDataColumn);
    inArray = inArray - repmat(mean(inArray),size(inArray,1),1);;
    inArray(:,xDataColumn) = time;
end

% Plot
nPlot = 1;
for ii = 1:size(inArray,2)
    if ii ~= xDataColumn
        if islogical(p.Results.colors)
            % If no color was specified, and array doesn't have five
            % columns, let MATLAB decide color
            plot(inArray(:,xDataColumn), inArray(:,ii),p.Results.style);
        else
            % If color was specified by user and/or MATLAB, use it!
            plot(inArray(:,xDataColumn), inArray(:,ii),p.Results.style,'Color',p.Results.colors(nPlot,:));
        end
        nPlot = nPlot + 1;
    end
end

end

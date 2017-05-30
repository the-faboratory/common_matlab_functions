function [ completeXValues,completeYValues ] = getPatches( topYValues, bottomYValues, xValues )
% GETPATCHES Gets a sequence of vertices to outline the input points, which 
% are typically confidence intervals of bins for plotting "clouds".
%   [ completeXValues, completeYValues ] = GETPATCHES( topYValues,
%   bottomYValues, xValues ) Gets a sequence of vertices to outline the
%   input points defined by the three inputs, (topYValues, bottomYValues,
%   and xValues) - which  are typically confidence intervals of bins for 
%   plotting "clouds".
%
%   Required Inputs: 
%   TOPYVALUES - vector with the y values of the points on the top of your
%   desired cloud. *Assumes this vector is in "increasing corresponding
%   x value" order.*
%   BOTTOMYVALUES - vector with the y values of the points on the bottom of
%   your desired cloud. *Assumes this vector is in "increasing corresponding
%   x value" order.*
%   XVALUES - common x values of the points of your desired cloud. *Assumes
%   you input a y value for the top and bottom at each desired x location.*
%
%   Optional inputs  (positional):
%   N/A
%   Optional Parameters (not positional, specified by an identifying string):
%   N/A
%
%   Outputs:
%   COMPLETEXVALUES, COMPLETEYVALUES - complete coordinates for your cloud.

% TODO: 
% 1. (Low Priority) Preallocate arrays reverseXValues and reverseBottomY

% Check that all inputs were vectors.
if ~isvector(topYValues)
    warning('Inputs to getPatches should be vectors. "topYValues" is not a vector')
elseif ~isvector(bottomYValues)
    warning('Inputs to getPatches should be vectors. "bottomYValues" is not a vector')
elseif ~isvector(xValues)
    warning('Inputs to getPatches should be vectors. "xValues" is not a vector')
end
length = max(size(xValues)); % find length of vector

% Flip x and bottom y, so we are an the order that the "patch" function
% expects: clockwise. (Alternately, we could have gone counterclockwise.)
for a=1:length
    reverseXValues(a) = xValues(length-a+1);
    reverseBottomY(a) = bottomYValues(length-a+1);
end

% Create output vectors by combining top and bottom points.
completeXValues = [xValues, reverseXValues];
completeYValues = [topYValues, reverseBottomY];
end

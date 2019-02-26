function [ filtered ] = expFilter( input, expConst )
%EXPFILTER apply exponential filter to data
%   [ filtered ] = EXPFILTER( INPUT, EXPCONST ) applies an exponential
%   filter to all data in input matrix row by row, using constant EXPCONST
%   TODO: 
%   1. (High Priority) replace with matlab's "filter" function

    % Initialize array
    filtered = zeros(size(input));
    filtered(1,:) = input(1,:);
    
    % Apply exponential filter to all columns of data
    for ii = 2:size(input,1) %All rows
        filtered(ii,:) = filtered(ii-1,:)*expConst + (1-expConst)*input(ii,:);
    end
end


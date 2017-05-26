function [ celery ] = ImportData( files, folder, format, numcol, numhead )
% Import Data - Only run this once because it takes forever to import data
% % Column Headers [Time Extension Load Voltage Strain Stress]

celery = cell(size(files,1),1);
for i = 1:size(files,2)
    filename = fopen([folder files{i} '.csv']);
    tmpCelery = textscan(filename,format,'headerlines',numhead);
    newFormat = zeros(length(tmpCelery{1}),numcol); % initialize each cell of celery w/ proper format
    for j = 1:numcol
        newFormat(:,j) = tmpCelery{j};
    end
    celery{i} = newFormat;
    i
end


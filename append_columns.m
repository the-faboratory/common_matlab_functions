function expanded_array = append_columns(destination_array, dest_time_col, source_array, source_time_col, columns_to_add, varargin)
% append_column Append a column from a source array onto a destination array that has more rows than the source. 
%  expanded_array = append_column(destination_array, dest_time_col, source_array, source_time_col, columns_to_add)
%  Appends columns_to_add from the source_array into the destination_array, such that the times in dest_time_col and source_time_col match
%
%  Example:
%  sensor_data_expanded = append_column(sensor_data, time_column_arduino, instron, time_column, displacement_column);
%

p = inputParser;
addRequired(p, 'destination_array', @isnumeric)
addRequired(p, 'dest_time_col', @isnumeric)
addRequired(p, 'source_array', @isnumeric)
addRequired(p, 'source_time_col', @isnumeric)
addRequired(p, 'columns_to_add', @isnumeric)
% addRequired(p, 'cell_array_of_data', @iscell)
addParameter(p, 'scale_factor', 1000, @isnumeric)
addParameter(p, 'source_more_rows', false, @islogical)
% addParameter(p, 'yConstant', 1, @isnumeric)

parse(p, destination_array, dest_time_col, source_array, source_time_col, columns_to_add, varargin{:})




%% Loop over data, and 
num_rows = size(destination_array, 1);
num_columns_initial = size(destination_array, 2);
num_columns_add = size(columns_to_add, 2);
expanded_array = [destination_array, zeros(num_rows, num_columns_add)];
added_col = size(expanded_array, 2);

current_row_source = 1;
rows_source = size(source_array, 1);
next_time_source = 0;

% Are there more rows in the source array?
source_more_rows = false;
if(rows_source > num_rows)
    source_more_rows = true;
end

if(source_more_rows)
    for row = 1:num_rows
        current_time = destination_array(row, dest_time_col) / p.Results.scale_factor;
        % Only increment "next row" if there's another row available
        if current_row_source > rows_source
            break
        end
            
        % If we crossed the "next time in the source array", increment the
        % current row for the source array
        while (current_time > next_time_source)
            next_row_source = current_row_source + 1;
            next_time_source = source_array(next_row_source, source_time_col);
            current_row_source = next_row_source;
        end

        expanded_array(row, num_columns_initial + 1:num_columns_initial + num_columns_add) = source_array(current_row_source, columns_to_add);
    end
else
    for row = 1:num_rows
        current_time = destination_array(row, dest_time_col) / p.Results.scale_factor;
        % Only increment "next row" if there's another row available
        if current_row_source < rows_source
            next_row_source = current_row_source + 1;
            next_time_source = source_array(next_row_source, source_time_col);
        end
        
        % If we crossed the "next time in the source array", increment the
        % current row for the source array
        if (current_time > next_time_source)
            current_row_source = next_row_source;
        end

        expanded_array(row, num_columns_initial + 1:num_columns_initial + num_columns_add) = source_array(current_row_source, columns_to_add);
    end
end

garbage = 1;

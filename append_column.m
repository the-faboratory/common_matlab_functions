function expanded_array = append_column(destination_array, dest_time_col, source_array, source_time_col, column_to_add)
% append_column Append a column from a source array onto a destination array that has more rows than the source. 
%  expanded_array = append_column(destination_array, dest_time_col, source_array, source_time_col, column_to_add)
%  Appends column_to_add from the source_array into the destination_array, such that the times in dest_time_col and source_time_col match
%
%  Example:
%  sensor_data_expanded = append_column(sensor_data, time_column_arduino, instron, time_column, displacement_column);
%

%% Loop over data, and 
num_rows = size(destination_array, 1);
expanded_array = [destination_array, zeros(num_rows, 1)];
added_col = size(expanded_array, 2);

current_row_source = 1;
rows_source = size(source_array, 1);

for row = 1:num_rows
    current_time = destination_array(row, dest_time_col) / 1000.0;
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

    expanded_array(row, added_col) = source_array(current_row_source, column_to_add);
end

garbage = 1;

function [ cellArray2Dyl ] = OnlyIncreasing( celeryF, column, skipFirst )

slimIndex = 1;
temp = celeryF{1,1};
Array2Dyl(1,:) = temp(1,:);
first = true;
for row = 2: size(temp,1)
    % Don't add to array if it's the first cycle and we were told to 
    % skip first cycle
    if temp(row,column)>temp(row-1,column) && ~(skipFirst && first)  
        Array2Dyl(slimIndex,:) = temp(row,:);
        slimIndex = slimIndex + 1;
    elseif temp(row,column)<temp(row-1,column)
        first = false;
    end
end
cellArray2Dyl = {Array2Dyl};
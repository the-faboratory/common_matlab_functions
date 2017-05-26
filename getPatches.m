function [ x,y ] = getPatches( topBounds, bottomBounds, time )
% TODO: Documentation

length = max(size(time));

for a=1:length
    reversetime(a) = time(length-a+1);
    reversebot(a) = bottomBounds(length-a+1);
end

x = [time, reversetime];
y = [topBounds, reversebot];
end


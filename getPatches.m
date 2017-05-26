function [ x,y ] = getPatches( topBounds, botBounds, time )

length = max(size(time));

for a=1:length
    reversetime(a) = time(length-a+1);
    reversebot(a) = botBounds(length-a+1);
end

x = [time, reversetime];
y = [topBounds, reversebot];
end


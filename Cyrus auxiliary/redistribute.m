function [updatedSnake, nAvailTag] = redistribute(snake, minSpacing, maxSpacing, availTag)

% [updatedSnake, nAvailTag] = redistribute(snake, minSpacing, maxSpacing, availTag)
%
% Creates and/or deletes vertices, as necessary, so inter-vertex spacing
% of snake is within desired minimum and maximum.
%
%   snake           the snake
%
%   minSpacing      minimum distance between adjacent snake vertices;
%                   if two vertices move within this distance of
%                   each other, one is deleted
%
%   maxSpacing      maximum distance between adjacent snake vertices;
%                   if two vertices exceed this distance between them,
%                   a new vertex is inserted between them
%
%   availTag        the next available unique tag (to be assigned to
%                   the next new vertex that is created, if applicable)
%
% Returns:
%
%   snake           the updated snake
%
%   nAvailTag       the updated next available unique tag after any
%                   new vertices were created
%
% Cyrus A Wilson  March 2003


len = size(snake, 1);
tempSnake = [snake(len, :); snake(1:len, :)];
o = 1;

while o <= len
    m = o + 1;
    tLen = len + 1;
    dist = sqrt((tempSnake(m, 1) - tempSnake(o, 1))^2 + ...
                (tempSnake(m, 2) - tempSnake(o, 2))^2);
    if dist > maxSpacing
        newPoint = [0.5 * (tempSnake(o, 1:2) + tempSnake(m, 1:2)), ...
                    availTag];
        availTag = availTag + 1;
        tempSnake = [tempSnake(1:o, :); ...
                     newPoint; ...
                     tempSnake(m:tLen, :)];
        len = len + 1;
    elseif dist < minSpacing
        tempSnake = [tempSnake(1:o, :); ...
                     tempSnake((m + 1):tLen, :)];
        len = len - 1;
        o = o - 1;
    end
    o = o + 1;
end

updatedSnake = tempSnake(2:len + 1, :);
nAvailTag = availTag;

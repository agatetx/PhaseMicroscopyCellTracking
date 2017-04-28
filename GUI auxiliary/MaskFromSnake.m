 function [mask] = MaskFromSnake(snake, m, n)
% 
% the function creates mask from GUI.
% 
% input:
%    snake - snake to be converted into mask.  
%    m, n - size of desired mask.  
%    
% output: 
%     mask - the mask created from the snake.
%     
    
    
Xvec = snake(:,1);
Yvec = snake(:,2);
Xvec(end+1) = Xvec(1);
Yvec(end+1) =Yvec(1);
mask = poly2mask(Xvec, Yvec, m, n);

end
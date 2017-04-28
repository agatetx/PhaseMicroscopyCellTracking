function [closestDot] = findClosestPoint(pointList, centroid, disp)
% 
% [closestDot] = findClosestPoint(pointList,dot)
% 
% The function returns the closest point in the pointList to the point given.
% 
% Input: 
%     pointList - array of points
%     dot - a point 
%     
% Output:
%     closestDot - the closest point to the point given.
%  

    P1 = centroid;
    P2 = centroid + disp;
    
    a = (P2(2) - P1(2))/(P2(1) - P1(1));
    b = -a*P1(1) + P1(2);
    
    d = abs((pointList(:,2) - a*pointList(:,1) - b) / sqrt(1+a^2+b^2)); 
    dot_prod = disp*(bsxfun(@minus, pointList(:,1:2), P1))'; 
    
    valid_points = dot_prod > 0;
    ind_vec = find(dot_prod > 0);
    
    [m, ind] = min(d(valid_points));
    closestDot = pointList(ind_vec(ind), 1:2);
      
function [res, scale] = dot_scaling(dot,m,n)

if( m > n )
    scale = 512 / m;
    shift = ((m-n)*scale/2);

    res = [(dot(1)*scale+shift) (dot(2)*scale)];
else 
    scale = 512 / n;
    shift = ((n-m)*scale/2);

    res = [(dot(1)*scale) (dot(2)*scale+shift)]; 
end
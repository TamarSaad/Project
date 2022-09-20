function [xc,LocalSlope]=detect_negative_slope(xx,yy)
    

Smoothed_yy=smooth(yy);

LocalSlope=diff(Smoothed_yy(:))./diff(xx(:));

xc=xx(find(LocalSlope>0,1,'last'));

if isempty(xc), xc=xx(1); end



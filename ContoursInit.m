function states = ContoursInit(fs)
% ContoursInit - initializes the plot of multiple contours
%
% See ContourInit (without "s") for a more complete description 
%
% INPUT
%
% fs      A cell array vector of functions that takes a linear
%         functional of coefficients [a;b] and return the point
%         [cx;cy] in the convex set that maximizes a*cx + b*cy
%
% OUTPUT
%
% states  A cell array vector of states
    assert(isvector(fs));
    m = length(fs);
    states = cell(1, m);
    for i = 1:length(fs)
        states{i} = ContourInit(fs{i});
    end
end

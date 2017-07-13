function ContoursPlot(states, styles)
% ContoursPlot - plots a contour
%
% INPUT
%
% states      Current states of contours
%
% styles      Cell array vector of styles
    for s = 1:length(states)
        ContourPlot(states{s}, styles{s});
    end
end

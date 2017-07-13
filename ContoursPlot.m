function ContoursPlot(states, stylesCA)
% ContoursPlot - plots a contour
%
% INPUT
%
% states      Current states of contours
%
% stylesCA    Cell array vector of styles
    for s = 1:length(states)
        ContourPlot(states{s}, stylesCA{s});
    end
end

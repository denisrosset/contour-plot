function ContourPlot(state, style)
% ContourPlot - plots a contour
%
% INPUT
%
% state         Current state of the contour
%
% style         A struct whose values are cell arrays,
%               representing parameters passed to fill/plot
%               If the value is not present, the corresponding
%               plot is ignored
%
% style.fill    Fill style for the triangle representing the
%               area between the inner and outer approximations
%
% style.bezier  Plot style for the quadratic approximation of
%               the boundary of the convex set
% style.inner   Plot style for the inner approximation
% style.outer   Plot style for the outer approximation
    n = length(state.angle);
    if isfield(style, 'fill')
        s = style.fill;
        for i = 1:n
            j = mod(i, n) + 1;
            pt1 = state.pt(:,i);
            pt2 = state.pt(:,j);
            pt3 = state.out(:,i);
            pts = [pt1 pt2 pt3 pt1];
            fill(pts(1,:), pts(2,:), s{:});
        end
    end
    if isfield(style, 'bezier')
        s = style.bezier;
        % using http://blogs.mathworks.com/graphics/2014/10/13/bezier-curves/
        t = linspace(0,1,31);
        for i = 1:n
            j = mod(i, n) + 1;
            pt1 = state.pt(:,i);
            pt2 = state.out(:,i);
            pt3 = state.pt(:,j);
            pts = kron((1-t).^2,pt1) + kron(2*(1-t).*t,pt2) + kron(t.^2,pt3);
            plot(pts(1,:), pts(2,:), s{:});
        end
    end
    if isfield(style, 'outer')
        s = style.outer;
        plot([state.out(1,:) state.out(1,1)], [state.out(2,:) state.out(2,1)], s{:});
    end
    if isfield(style, 'inner')
        s = style.inner;
        plot([state.pt(1,:) state.pt(1,1)], [state.pt(2,:) state.pt(2,1)], s{:});
    end
end

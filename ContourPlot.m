function ContourPlot(state, styles)
% ContourPlot - plots a contour
%
% INPUT
%
% state         Current state of the contour
%
% styles        A struct whose values are cell arrays,
%               representing parameters passed to fill/plot
%               If the value is not present, the corresponding
%               plot is ignored
%
% styles.fill   Fill style for the triangle representing the
%               area between the inner and outer approximations
%
% styles.bezier Plot style for the quadratic approximation of
%               the boundary of the convex set
% styles.inner  Plot style for the inner approximation
% styles.outer  Plot style for the outer approximation
    n = length(state.angle);
    if isfield(styles, 'fill')
        style = styles.fill;
        for i = 1:n
            j = mod(i, n) + 1;
            pt1 = state.pt(:,i);
            pt2 = state.pt(:,j);
            pt3 = state.out(:,i);
            pts = [pt1 pt2 pt3 pt1];
            fill(pts(1,:), pts(2,:), style{:});
        end
    end
    if isfield(styles, 'bezier')
        style = styles.bezier;
        % using http://blogs.mathworks.com/graphics/2014/10/13/bezier-curves/
        t = linspace(0,1,31);
        for i = 1:n
            j = mod(i, n) + 1;
            pt1 = state.pt(:,i);
            pt2 = state.out(:,i);
            pt3 = state.pt(:,j);
            pts = kron((1-t).^2,pt1) + kron(2*(1-t).*t,pt2) + kron(t.^2,pt3);
            plot(pts(1,:), pts(2,:), style{:});
        end
    end
    if isfield(styles, 'outer')
        style = styles.outer;
        plot([state.out(1,:) state.out(1,1)], [state.out(2,:) state.out(2,1)], style{:});
    end
    if isfield(styles, 'inner')
        style = styles.inner;
        plot([state.pt(1,:) state.pt(1,1)], [state.pt(2,:) state.pt(2,1)], style{:});
    end
end

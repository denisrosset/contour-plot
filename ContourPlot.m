function ContourPlot(state, color, bezier)
    if nargin < 3
        bezier = 0;
    end
    if nargin < 2
        color = [1 0 0];
    end
    n = length(state.angle);
    for i = 1:n
        j = mod(i, n) + 1;
        pt1 = state.pt(:,i);
        pt2 = state.pt(:,j);
        pt3 = state.out(:,i);
        pts = [pt1 pt2 pt3 pt1];
        fill(pts(1,:), pts(2,:), '', 'FaceColor', color, 'FaceAlpha', 0.2, 'LineStyle', 'none');
    end
    if bezier
        % using http://blogs.mathworks.com/graphics/2014/10/13/bezier-curves/
        t = linspace(0,1,31);
        for i = 1:n
            j = mod(i, n) + 1;
            pt1 = state.pt(:,i);
            pt2 = state.out(:,i);
            pt3 = state.pt(:,j);
            pts = kron((1-t).^2,pt1) + kron(2*(1-t).*t,pt2) + kron(t.^2,pt3);
            plot(pts(1,:), pts(2,:), '', 'Color', color);
        end
    else
        plot([state.pt(1,:) state.pt(1,1)], [state.pt(2,:) state.pt(2,1)], '', 'Color', color);
    end
        plot([state.pt(1,:) state.pt(1,1)], [state.pt(2,:) state.pt(2,1)], 'o', 'Color', color);
end

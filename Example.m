function Example
    state = ContourInit(@circlef);
    for i = 1:10
	state = ContourUpdate(@circlef, state);
	styles = struct;
	styles.fill = {'', 'FaceColor', [1 0 0], 'FaceAlpha', 0.2, 'LineStyle', 'none'};
	styles.bezier = {'-', 'Color', [1 0 0]};
        clf;
        hold on;
	ContourPlot(state, styles);
        drawnow;
    end
    function pt = circlef(lin)
    % function that defines a circle of radius 1
	x = sdpvar;
	y = sdpvar;
	optimize(norm([x;y]) <= 1, -lin(1)*x-lin(2)*y);
	pt = [double(x); double(y)];
    end
end

function ExampleMulti
    fs = {@circlef @shapef};
    style = struct;
    style1.fill = {'', 'FaceColor', [1 0 0], 'FaceAlpha', 0.2, 'LineStyle', 'none'};
    style1.bezier = {'-', 'Color', [1 0 0]};
    style1.inner = {'x', 'Color', [1 0 0]};
    style1.outer = {'o', 'Color', [1 0 0]};
    style2.fill = {'', 'FaceColor', [0 0 1], 'FaceAlpha', 0.2, 'LineStyle', 'none'};
    style2.bezier = {'-', 'Color', [0 0 1]};
    style2.inner = {'x', 'Color', [0 0 1]};
    style2.outer = {'o', 'Color', [0 0 1]};
    styles = {style1 style2};
    states = ContoursInit(fs);
    clf;
    hold on;
    ContoursPlot(states, styles);
    axis([-1.5 1.5 -1.5 1.5]);
    drawnow;
    for i = 1:30
	states = ContoursUpdate(fs, states);
        clf;
        hold on;
	ContoursPlot(states, styles);
        axis([-1.5 1.5 -1.5 1.5]);
        drawnow;
    end
    function pt = circlef(lin)
    % function that defines a circle of radius 1
	x = sdpvar;
	y = sdpvar;
	optimize(norm([x;y]) <= 1, -lin(1)*x-lin(2)*y);
	pt = [double(x); double(y)];
    end
    function pt = shapef(lin)
	x = sdpvar;
	y = sdpvar;
	optimize([norm([2*x;y]) <= 1;x+y >= -1/2], -lin(1)*x-lin(2)*y);
	pt = [double(x); double(y)];
    end
end

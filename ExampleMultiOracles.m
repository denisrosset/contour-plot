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
clf;
hold on;
oracles = {@CircleOracle @SquareOracle};
S = ContourDataSet.fromOracles(oracles);
S.plot(styles);
axis([-1.5 1.5 -1.5 1.5]);
drawnow;
for i = 1:30
    S = S.updatedOracles(oracles);
    clf;
    hold on;
    S.plot(styles);
    axis([-1.5 1.5 -1.5 1.5]);
    drawnow;
end

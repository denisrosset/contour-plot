data = ContourData.fromOracle(@CircleOracle)
for i = 1:15
    data = data.updatedOracle(@CircleOracle);
    styles = struct;
    styles.fill = {'', 'FaceColor', [1 0 0], 'FaceAlpha', 0.2, 'LineStyle', 'none'};
    styles.bezier = {'-', 'Color', [1 0 0]};
    clf;
    hold on;
    data.plot(styles);
    axis([-2 2 -2 2]);
    drawnow;
end

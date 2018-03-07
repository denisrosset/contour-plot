data = ContourData.fromCVX(@CircleCVX)
for i = 1:15
    data = data.updatedCVX(@CircleCVX);
    styles = struct;
    styles.fill = {'', 'FaceColor', [1 0 0], 'FaceAlpha', 0.2, 'LineStyle', 'none'};
    styles.bezier = {'-', 'Color', [1 0 0]};
    clf;
    hold on;
    data.plot(styles);
    axis([-2 2 -2 2]);
    drawnow;
end

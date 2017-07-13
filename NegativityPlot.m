ind = 1;
% stylesCA is a cell array of styles (see Contour(s)Plot)
stylesCA = cell(1, 8);
% fs is a cell array of functions that maximize a 
fs = cell(1, 8);
for level = 1:2
    switch level
      case 1
        color = [1 0 1];
      case 2
        color = [0 0.5 1];
    end
    for neg = [0.2 0.3 inf]
        styles = struct;
        styles.fill = {'', 'FaceColor', color, 'FaceAlpha', 0.2, 'LineStyle', 'none'};
        switch neg
          case 0.2
            f = NegativityFun(neg, level);
            styles.bezier = {':', 'Color', color, 'LineWidth', 2};
          case 0.3
            f = NegativityFun(neg, level);
            styles.bezier = {'--', 'Color', color, 'LineWidth', 2};
          otherwise
            f = NegativityFun('Q', level);
            styles.bezier = {'-', 'Color', color, 'LineWidth', 2};
        end
        fs{ind} = f;
        stylesCA{ind} = styles;
        ind = ind + 1;
    end
end
styles = struct;
color = [1 0 0];
styles.fill = {'', 'FaceColor', color, 'FaceAlpha', 0.2, 'LineStyle', 'none'};
styles.bezier = {'-', 'Color', color, 'LineWidth', 2};
stylesCA{ind} = styles;
fs{ind} = NegativityFun('N', []);
ind = ind + 1;
styles = struct;
color = [0 0 0];
styles.fill = {'', 'FaceColor', color, 'FaceAlpha', 0.2, 'LineStyle', 'none'};
styles.bezier = {'-', 'Color', color, 'LineWidth', 2};
stylesCA{ind} = styles;
fs{ind} = NegativityFun('L', []);
ind = ind + 1;

states = ContoursInit(fs);

clf;
hold on;
ContoursPlot(states, stylesCA);
axis([-0.6 1.6 -1 1.2]);
f = getframe;
[im, map] = rgb2ind(f.cdata, 256, 'nodither');
im(:,:,1,1) = rgb2ind(f.cdata, map, 'nodither');
for frame = 2:70
    newstates = ContoursUpdate(fs, states);
    states = newstates;
    clf;
    hold on;
    ContoursPlot(states, stylesCA);
    axis([-0.6 1.6 -1 1.2]);
    f = getframe;
    im(:,:,1,frame) = rgb2ind(f.cdata, map, 'nodither');
end
imwrite(im,map,'anim.gif','DelayTime',0.1,'LoopCount',inf);

function pt = pt_intersect(x1y1, a, x2y2, b)
% [x1;y1] + r1 [cos a;sin a] == [x2;y2] + r2 [cos b; sin b]
    x1 = x1y1(1);
    y1 = x1y1(2);
    x2 = x2y2(1);
    y2 = x2y2(2);
    r1r2 = [cos(a) -cos(b)
            sin(a) -sin(b)]\[x2-x1;y2-y1];
    c1 = [x1;y1] + r1r2(1) * [cos(a);sin(a)];
    c2 = [x2;y2] + r1r2(2) * [cos(b);sin(b)];
    pt = c1;
end

function area = triangle_area(pt1, pt2, pt3)
% triangle_area Returns the area of the triangle whose vertices are given
    a = norm(pt1 - pt2);
    b = norm(pt2 - pt3);
    c = norm(pt3 - pt1);
    s = (a + b + c)/2;
    area = sqrt(s*(s-a)*(s-b)*(s-c));
end

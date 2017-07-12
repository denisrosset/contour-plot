function state = ContourUpdate(f, state)
% ConvexContour - adds a point to a convex set contour
%
% Refines the contour where the area between the inner and outer
% approximations is the greatest
%
    tol = 1e-8;
    pt = state.pt;
    angle = state.angle;
    out = state.out;
    area = state.area;
    n = length(angle);
    % finds the triangle with greatest area
    i = find(area == max(area));
    i = i(1);
    % next point (corresponds to i + 1)
    j = mod(i, n) + 1;
    pti = pt(:,i);
    ptj = pt(:,j);
    diff = ptj - pti;
    diff = diff/norm(diff);
    % linear functional is the normal to the tangent
    lin = [diff(2); -diff(1)];
    newangle = modpi(atan2(lin(2), lin(1))+pi/2);
    newpt = f(lin);
    % do we have a new point with a greater value?
    test = abs(dot(lin,newpt) - dot(lin,pti));
    if test < tol
        % if no, the contour is flat between i and j
        newpt = (pti + ptj)/2;
        area1 = 0;
        area2 = 0;
        out1 = pti;
        out2 = ptj;
    else
        % if yes, we have an additional point outside the convex
        % hull and we improve the inner approximation
        out1 = pt_intersect(pti, angle(i), newpt, newangle);
        out2 = pt_intersect(newpt, newangle, ptj, angle(j));
        area1 = triangle_area(pt(:,i), newpt, out1);
        area2 = triangle_area(newpt, pt(:,j), out2);
    end
    angle = [angle(1:i) newangle angle(i+1:n)];
    pt = [pt(:,1:i) newpt pt(:,i+1:n)];
    out = [out(:,1:i-1) out1 out2 out(:,i+1:n)];
    area = [area(1:i-1) area1 area2 area(i+1:n)];
    state = struct('pt', pt, ...
                   'angle', angle, ...
                   'out', out, ...
                   'area', area);
end
function state = ContourInit(f, angles)
% ContourInit - initializes the plot of the contour of a convex set
%
% INPUT
%
% f       Function that takes a linear functional of coefficients [a;b] 
%         and returns the point [cx;cy] in the convex set that maximizes
%         a*cx + b*cy
%
% angles  (Optional) angles = [a1 a2 a3] such that
%         0 <= a1 < a2 < a3 <= 2*pi
%
% OUTPUT
%
% state   Initial state of a contour with 3 points
%
% Explanation of the state data structure
%
% For a contour made of n points, we have
% state.pt(2,n)
% state.angle(1,n)
% state.out(2,n)
% state.area(1,n)
%
% The components are interpreted as follows:
%
% The i-th point is given by coordinates pt(:,i) and
% angle(:,i) is the angle of the tangent to the boundary 
% at this point, with value between 0 and pi.
%
% The points are sorted counter-clockwise (trigonometric order), so
% that an inner approximation of the set can be obtained by
% plotting the half-lines:
% pt(:,1) -> pt(:,2) -> ... -> pt(:,n) -> pt(:,1)
%
% By intersecting the tangents, one obtains an outer approximation
% of the convex set composed of the points 
% out(:,1) -> out(:,2) -> ... out(:,n) -> out(:,1)
%
% The inner and outer approximations match so that the
% boundary of the convex set lies always in the triangle given by
%
% pt(:,i) -> out(:,i) -> pt(:,i+1)
%
% where i+1 wraps.
%
% We memorize the area of the triangle corresponding to out(:,i)
% in area(i).
    if nargin < 2
        % if angles are not provided, take a division of 2*pi into
        % three parts, with a random shift
        angles = rand*pi + (0:2)*2*pi/3;
    end
    pt = zeros(2, 3);
    angle = zeros(1, 3);
    out = zeros(2, 3);
    area = zeros(1, 3);
    % compute initial points in the approximation and the tangent angles
    for i = 1:3
        a = mod2pi(angles(i));
        currentpt = f([cos(a); sin(a)]);
        pt(:, i) = currentpt(:);
        angle(i) = modpi(a + pi/2);
    end
    % compute the outer approximation
    for i = 1:3
        j = mod(i,3) + 1; % i+1
        out(:,i) = pt_intersect(pt(:,i), angle(i), pt(:,j), angle(j));
        area(i) = triangle_area(pt(:,i),pt(:,j),out(:,i));
    end
    % populate the structure
    state = struct('pt', pt, ...
                   'angle', angle, ...
                   'out', out, ...
                   'area', area);
end

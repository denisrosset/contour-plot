classdef ContourData
    properties
        points = []; % 2 x n
        angles = [];  % 1 x n
        out = [];    % 2 x n
        area = [];   % 1 x n
        % Explanation of these properties
        %
        % For a contour made of n points, we have
        % data.points(2,n)
        % data.angles(1,n)
        % data.out(2,n)
        % data.area(1,n)
        %
        % The components are interpreted as follows:
        %
        % The i-th point is given by coordinates points(:,i) and
        % angles(:,i) is the angle of the tangent to the boundary 
        % at this point, with value between 0 and pi.
        %
        % The points are sorted counter-clockwise (trigonometric order), so
        % that an inner approximation of the set can be obtained by
        % plotting the half-lines:
        % points(:,1) -> points(:,2) -> ... -> points(:,n) -> points(:,1)
        %
        % By intersecting the tangents, one obtains an outer approximation
        % of the convex set composed of the points 
        % out(:,1) -> out(:,2) -> ... out(:,n) -> out(:,1)
        %
        % The inner and outer approximations match so that the
        % boundary of the convex set lies always in the triangle given by
        %
        % points(:,i) -> out(:,i) -> points(:,i+1)
        %
        % where i+1 wraps.
        %
        % We memorize the area of the triangle corresponding to out(:,i)
        % in area(i).
    end
    methods
        function data = ContourData(points, angles, out, area)
        % CONTOURDATA Initializes a ContourData instance from extremal points and tangent angles
            n = size(points, 2);
            assert(size(points, 1) == 2);
            assert(length(angles) == n);
            angles = angles(:)';
            if nargin < 3 % computes outer approximation if necessary
                out = zeros(2, n);
                for i = 1:n
                    j = mod(i,n) + 1; % i+1
                    out(:,i) = ContourData.intersect(points(:,i), angles(i), points(:,j), angles(j));
                end
            end
            if nargin < 4 % computes areas if necessary
                area = zeros(1, n);
                for i = 1:n
                    j = mod(i,n) + 1; % i+1
                    area(i) = ContourData.triangleArea(points(:,i), points(:,j), out(:,i));
                end
            end
            data.points = points;
            data.angles = angles;
            data.out = out;
            data.area = area;
        end
        function plot(data, style)
        % ContourPlot - plots a contour
        %
        % Inputs:
        %
        % data          Current state of the contour
        %
        % style         A struct whose values are cell arrays,
        %               representing parameters passed to fill/plot
        %               If the value is not present, the corresponding
        %               plot is ignored
        %
        % style.fill    Fill style for the triangle representing the
        %               area between the inner and outer approximations
        %
        % style.bezier  Plot style for the quadratic approximation of
        %               the boundary of the convex set
        % style.inner   Plot style for the inner approximation
        % style.outer   Plot style for the outer approximation
            n = length(data.angles);
            if isfield(style, 'fill')
                s = style.fill;
                for i = 1:n
                    j = mod(i, n) + 1;
                    pt1 = data.points(:,i);
                    pt2 = data.points(:,j);
                    pt3 = data.out(:,i);
                    pts = [pt1 pt2 pt3 pt1];
                    fill(pts(1,:), pts(2,:), s{:});
                end
            end
            if isfield(style, 'bezier')
                s = style.bezier;
                % using http://blogs.mathworks.com/graphics/2014/10/13/bezier-curves/
                t = linspace(0,1,31);
                for i = 1:n
                    j = mod(i, n) + 1;
                    pt1 = data.points(:,i);
                    pt2 = data.out(:,i);
                    pt3 = data.points(:,j);
                    pts = kron((1-t).^2,pt1) + kron(2*(1-t).*t,pt2) + kron(t.^2,pt3);
                    plot(pts(1,:), pts(2,:), s{:});
                end
            end
            if isfield(style, 'outer')
                s = style.outer;
                plot([data.out(1,:) data.out(1,1)], [data.out(2,:) data.out(2,1)], s{:});
            end
            if isfield(style, 'inner')
                s = style.inner;
                plot([data.points(1,:) data.points(1,1)], [data.points(2,:) data.points(2,1)], s{:});
            end
        end
        function newData = updatedCVX(data, cvxset)
            newData = data.updatedOracle(ContourData.setToOracle(cvxset));
        end
        function newData = updatedOracle(data, oracle)
        % UPDATEDORACLE - adds a point to a convex set contour
        %
        % Refines the contour where the area between the inner and outer
        % approximations is the greatest and returns the updated contour data
            tol = 1e-8;
            n = length(data.angles);
            % finds the triangle with greatest area
            i = find(data.area == max(data.area));
            i = i(1);
            % next point (corresponds to i + 1)
            j = mod(i, n) + 1;
            pti = data.points(:,i);
            ptj = data.points(:,j);
            diff = ptj - pti;
            diff = diff/norm(diff);
            % linear functional is the normal to the tangent
            lin = [diff(2); -diff(1)];
            newangle = mod(atan2(lin(2), lin(1))+3*pi/2, pi);
            newpt = oracle(lin);
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
                out1 = ContourData.intersect(pti, data.angles(i), newpt, newangle);
                out2 = ContourData.intersect(newpt, newangle, ptj, data.angles(j));
                area1 = ContourData.triangleArea(data.points(:,i), newpt, out1);
                area2 = ContourData.triangleArea(newpt, data.points(:,j), out2);
            end
            % insert the new data at the right place
            newAngles = [data.angles(1:i) newangle data.angles(i+1:n)];
            newPoints = [data.points(:,1:i) newpt data.points(:,i+1:n)];
            newOut = [data.out(:,1:i-1) out1 out2 data.out(:,i+1:n)];
            newArea = [data.area(1:i-1) area1 area2 data.area(i+1:n)];
            newData = ContourData(newPoints, newAngles, newOut, newArea);
        end
    end
    methods (Static)
        function pt = intersect(x1y1, a, x2y2, b)
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
        function area = triangleArea(pt1, pt2, pt3)
        % triangle_area Returns the area of the triangle whose vertices are given
            a = norm(pt1 - pt2);
            b = norm(pt2 - pt3);
            c = norm(pt3 - pt1);
            s = (a + b + c)/2;
            area = sqrt(s*(s-a)*(s-b)*(s-c));
        end
        function f = setToOracle(cvxset)
        % SETTOORACLE Converts a CVX set definition to an oracle
            f = @(lin) set_to_oracle(cvxset, lin);
        end
        function data = fromCVX(cvxset, varargin)
        % FROMCVX Initializes the contour data of a convex set
        %
        % See fromOracle, except that cvxset is a function defining a 2D convex set
        % according to the CVX conventions
            data = ContourData.fromOracle(ContourData.setToOracle(cvxset), varargin{:});
        end
        function data = fromOracle(oracle, angles)
        % FROMORACLE Initializes the contour data of a convex set
        %
        % Inputs:
        %
        % oracle  Function pt = oracle(lin) that takes a linear functional lin
        %         of coefficients [a;b] and returns the point pt = [cx;cy] in the convex set
        %         that maximizes a*cx + b*cy
        %
        % angles  (Optional) angles = [a1 a2 a3] such that
        %         0 <= a1 < a2 < a3 <= 2*pi
        %         Chosen as an equipartition of 2*pi with a random phase otherwise
        %
        % Outputs:
        %
        % data    Initial contour data with 3 points
            if nargin < 2
                % if angles are not provided, take a division of 2*pi into
                % three parts, with a random shift
                angles = rand*pi + (0:2)*2*pi/3;
            end
            points = zeros(2, 3);
            % compute initial points in the approximation and the tangent angles
            for i = 1:3
                a = mod(angles(i), 2*pi);
                currentpt = oracle([cos(a); sin(a)]);
                points(:, i) = currentpt(:);
                angles(i) = mod(a + pi/2, pi);
            end
            data = ContourData(points, angles);
        end
    end
end

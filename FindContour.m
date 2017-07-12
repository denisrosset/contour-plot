function [cx cy] = FindContour(P0, Px, Py, range, contourType, level, options)
% Finds the boundary of the local/quantum/nonsignaling set in a 2D slice
    P0_CG = Mat_CGFromFull22 * P0(:);
    cx = zeros(1, length(range));
    cy = zeros(1, length(range));
    for i = 1:length(range)
        yalmip clear;
        alpha = range(i);
        dir = cos(alpha)*(Px(:) - P0(:)) + sin(alpha)*(Py(:) - P0(:));
        dir_CG = Mat_CGFromFull22 * dir;
        v = sdpvar;
        pt_CG = P0_CG + v * dir_CG;
        switch contourType
          case 'L'
            C = LocalConstraints_CG22(pt_CG);
          case 'Q'
            C = NPAConstraints_CG22(pt_CG, level, true);
          case 'N'
            C = [Mat_FullFromCG22 * pt_CG >= 0];
          otherwise
            [C nu] = NegConstraints_CG22(pt_CG, level);
            C = [C
                 nu <= contourType];
        end
        optimize(C, -v, options);
        v = double(v);
        cx(i) = cos(alpha)*v;
        cy(i) = sin(alpha)*v;
    end
end

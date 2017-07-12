function f = ContourFun(contourType, level)
    data = load('PNeg.mat');
    P1 = data.PNeg;
    options = sdpsettings(SedumiOriginalSettings, 'sedumi.eps', 1e-8);
    Paxby = reshape(permute(P1, [1 3 2 4]), [4 4]);
    Pax = sum(Paxby, 2)/2;
    Pby = sum(Paxby, 1)/2;
    Pprod = permute(reshape(kron(Pax(:), Pby(:)), [2 2 2 2]), [1 3 2 4]);
    P0 = Pprod;
    Pdet = [0 1 0 1]';
    P2 = permute(reshape(kron(Pdet(:), Pdet(:)), [2 2 2 2]), [1 3 2 4]);
    P0_CG = Mat_CGFromFull22 * P0(:);
    x = sdpvar;
    y = sdpvar;
    P = P0(:) + x*(P1(:) - P0(:)) + y*(P2(:) - P0(:));
    P_CG = Mat_CGFromFull22 * P;
    switch contourType
      case 'L'
        C = LocalConstraints_CG22(P_CG);
      case 'Q'
        C = NPAConstraints_CG22(P_CG, level, true);
      case 'N'
        C = [Mat_FullFromCG22 * P_CG >= 0];
      otherwise
        [C nu] = NegConstraints_CG22(P_CG, level);
        C = [C
             nu <= contourType];
    end
    f = @fun;
    function pt = fun(v)
        optimize(C, -dot(v,[x;y]), options);
        pt = [double(x);double(y)];
    end
end

function pt = circlef(ineq)
    pt = sdpvar(2, 1);
    options = sdpsettings('verbose', 0);
    optimize([norm(pt) <= 1; pt(1) + pt(2) >= -1/2], -dot(ineq, pt), ...
             options);
    pt = double(pt);
end

function pt = CircleOracle(lin)
    cvx_begin
        variable pt(2)
        norm(pt, 2) <= 1
        maximize lin(1)*pt(1) + lin(2)*pt(2)
    cvx_end
end

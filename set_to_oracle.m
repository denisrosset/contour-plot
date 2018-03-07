function pt = set_to_oracle(cvxset, lin)
    cvx_begin
        variable pt(2)
        maximize lin(1)*pt(1)+lin(2)*pt(2)
        pt == cvxset()
    cvx_end
end

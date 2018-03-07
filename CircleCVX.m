function pt = CircleCVX
    cvx_begin set
        variable pt(2)
        norm(pt, 2) <= 1
    cvx_end
end

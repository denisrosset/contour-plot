function pt = SquareCVX
    cvx_begin set
        variable pt(2)
        norm(pt, 1) <= 1
    cvx_end
end

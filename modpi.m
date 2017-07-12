function a = modpi(a)
    while a < 0
        a = a + pi;
    end
    a = mod(a, pi);
end

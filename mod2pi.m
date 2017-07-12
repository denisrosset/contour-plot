function a = mod2pi(a)
    while a < 0
        a = a + 2*pi;
    end
    a = mod(a, 2*pi);
end

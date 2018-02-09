function  A2=get_A(j,gsc_mol)

    gam = 50;
    Ca = 400  ; %ppmv

    ci = 0;
    jump = 97;
    ct = 0;
    go = 1;

    while go
        ct = ct+ 1;
        ci = ci+ jump;

        A1 = j/4*(ci-gam)/(ci+2*gam);
        A2 = gsc_mol*(Ca-ci);

        if abs(A1-A2)<0.0001
            go   = 0;
        elseif A1>A2
            ci   = ci-jump;
            jump = jump/2.75;
        end

        if ct>100
            disp('photosynthesis not converging')
            go=0;
        end

    end

end


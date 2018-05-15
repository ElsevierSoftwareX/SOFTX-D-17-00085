function nelP = getnelP(nel,ndm,nelP3,nelP4,nelP6,nelP9)

    if ndm == 2
        if nel == 3
            nelP = nelP3;
        elseif nel == 4
            nelP = nelP4;
        elseif nel == 6
            nelP = nelP6;
        elseif nel == 9
            nelP = nelP9;
        else
            nelP = nel;
        end
    elseif ndm == 3
        if nel == 4
            nelP = nelP3;
        elseif nel == 8
            nelP = nelP4;
        elseif nel == 10
            nelP = nelP6;
        elseif nel == 27
            nelP = nelP9;
        else
            nelP = nel;
        end
    elseif ndm == 1
        if nel == 2
            nelP = nelP3;
        elseif nel == 3
            nelP = nelP4;
        elseif nel == 4
            nelP = nelP6;
        elseif nel == 5
            nelP = nelP9;
        else
            nelP = nel;
        end
    end
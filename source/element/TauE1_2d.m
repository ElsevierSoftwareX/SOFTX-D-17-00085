function [tau,intb] = TauE1_2d(xl,D,nel,lint3,lint4)
% 02/29/2012
% computes tau for edge bubble over a triangle for elasticity problem

tau = zeros(2,2);
ib = 0;
der = 0;
bf = 0;
intb = 0;

if nel == 3 || nel == 6
    
    lint = lint3;
    
    for l = 1:lint

        [Wgt,litr,lits] = intpntt(l,lint,ib);
        [shl,shld,shls,be] = shlt(litr,lits,3,3,der,bf);
        [shg, shgs, Jdet, be, xs] = shgt(xl,3,shld,shls,3,bf,der,be);

        [b,db] = edgebubble(litr,lits,nel);
    %     db = (db'*inv(xs))';
        db = (db'/xs)';
        Bmat = [db(1) 0
                0 db(2)
                db(2) db(1)];

        tau = tau + Jdet*Wgt*Bmat'*D*Bmat;
        intb = intb + Jdet*Wgt*b;

    end

else
    
    lint = lint4;
    
    for l = 1:lint

        [Wgt,litr,lits] = intpntq(l,lint,ib);
        [shl,shld,shls,be] = shlq(litr,lits,4,4,der,bf);
        [shg, shgs, Jdet, be, xs] = shgq(xl,4,shld,shls,4,bf,der,be);

        [b,db] = edgebubbleQ(litr,lits,nel);
    %     db = (db'*inv(xs))';
        db = (db'/xs)';
        Bmat = [db(1) 0
                0 db(2)
                db(2) db(1)];

        tau = tau + Jdet*Wgt*Bmat'*D*Bmat;
        intb = intb + Jdet*Wgt*b;

    end

end

tau = inv(tau);

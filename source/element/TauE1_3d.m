function [tau,intb,vol] = TauE1_3d(xl,D,nel)
%
% 05/16/2015 - edge tau tensor for 3d, linear elasticity

	intb=0;
    tau = zeros(3,3);
    vol = 0;
    
    ib = 0;
    bf = 0;
    der = 0;
    if nel == 4
        lint = 4;11;36;
    elseif nel == 8
        lint = 8;1000;64;27;
    elseif nel == 10
        lint = 24;36;
    else
        lint = 27;1000;
    end
        
    for l = 1:lint

        %Evaluate first derivatives of basis functions at int. point
        if nel == 4 || nel == 10
          [Wgt,ss] =  int3d_t(l,lint,ib);
          [~,shld,shls,be] = shltt(ss,nel,nel,der,bf);
          [~,~,Jdet,~,xs] = shgtt(xl,nel,shld,shls,nel,bf,der,be);

        else
          [Wgt,ss] =  intpntb(l,lint,ib);
          [~,shld,shls,be] = shlb(ss,nel,nel,der,bf);
          [~,~,Jdet,~,xs] = shgb(xl,nel,shld,shls,nel,bf,der,be);

        end
        
        if nel == 4 || nel == 10
        [b,db] = facebubbleT(ss,nel); 
        else
        [b,db] = facebubbleQ(ss,nel);   
        end
        db = (db'/xs);
                
        Bmat = [db(1)  0       0
                0       db(2)  0
                0       0       db(3)
                db(2)  db(1)  0
                0       db(3)  db(2)
                db(3)  0       db(1)];
            

    tau = tau + Jdet*Wgt*Bmat'*D*Bmat;
    intb = intb + Jdet*Wgt*b;
    vol = vol + Jdet*Wgt;

%         end %i
    end %j  ! End of Integration Loop
tau = inv(tau);

% Tim Truster
% 10/08/2014
% 2D CZ element, elastic stiffness only

switch isw %Task Switch
    
    case 1
        
        if ndf > 2
            
            for i = 3:ndf
                lie(i,1) = 0;
            end
            
        end
        
%%
    case {3,6} %interface stiffness
        
        ElemK = zeros(nst,nst);
        ElemF = zeros(nst,1);
        t1 = zeros(3,1);
        t2 = t1;
        t3 = t1;
        thick = 1;
        
        Kc = mateprop(5);%mateprop(8); % artificial stiffness
        
        Nmat = zeros(2,nst);
        
        ulres = reshape(ul,nst,1);
            
        if nel == 4
            lint = 2;
            xlEdge = xl;
        elseif nel == 6
            lint = 3;
            xlEdge = xl(:,[1 2 4 5 3 2 6 1 3]);
        end
        
        for ll = 1:lint
            
            [Wgt,r,s] = intpntq(ll,lint,1);
            
            if nel == 4
                [shlL,shld,shls,be] = shlq(r,s,4,4,0,0);
                [~, ~, ~, ~, xsL] = shgq(xlEdge,4,shld,shls,nen,0,0,0);
            elseif nel == 6
                [shlL,shld,shls,be] = shlq(r,s,9,9,0,0);
                [~, ~, ~, ~, xsL] = shgq(xlEdge,9,shld,shls,nen,0,0,0);
            end

            s = 1;
            
            if nel == 4
                [shlR,shld,shls,be] = shlq(r,s,4,4,0,0);
            elseif nel == 6
                [shlR,shld,shls,be] = shlq(r,s,9,9,0,0);
            end
            
            %Evaluate tangent and normal vectors
            t1 = [xsL(:,1); 0];
            [tm1, tu1] = VecNormalize(t1);
            t2 = [0; 0; 1];
            tm2 = 1;
            tu2 = t2';
            t3 = VecCrossProd(t1,t2);
            [tm3, tu3] = VecNormalize(t3);
            nLx = tu3(1);
            nLy = tu3(2);
            nvect = [nLx 0 nLy
                     0 nLy nLx];
            nvec = [nLx; nLy];
                    
            c1 = Wgt*tm3*thick;
            
            if nel == 4
            for i = 1:2
                Nmat(1,(i-1)*ndf+1) = -shlL(i);
                Nmat(2,(i-1)*ndf+2) = -shlL(i);
            end
            for i = 3:4
                Nmat(1,(i-1)*ndf+1) = shlR(i);
                Nmat(2,(i-1)*ndf+2) = shlR(i);
            end
            elseif nel == 6
            inds = [1 2 5 3 4 7];
            for i = 1:3
                Nmat(1,(i-1)*ndf+1) = -shlL(inds(i));
                Nmat(2,(i-1)*ndf+2) = -shlL(inds(i));
            end
            for i = 4:6
                Nmat(1,(i-1)*ndf+1) = shlR(inds(i));
                Nmat(2,(i-1)*ndf+2) = shlR(inds(i));
            end
            end
            
            jumpu = Nmat*ulres;    %displacement jump
            normu = norm(jumpu);
            dn = jumpu'*nvec;
            ushear = jumpu - dn*nvec;
            Rmat = [nvec tu1(1:2)']';
            ds = Rmat(2,1:2)*ushear;
            ts = Kc*ds;
            tn = Kc*dn;
            Cnn = Kc;
            Css = Cnn;
            Cns = 0;
            tvec = Rmat'*[tn; ts];
            Kmat = Rmat'*[Cnn Cns; Cns Css]*Rmat;
            
            % Force terms
            ElemF = ElemF - c1*(Nmat'*tvec);

            % Penalty terms
            ElemK = ElemK + c1*(Nmat'*Kmat*Nmat);
            
        end %lint

    ElemK;
            
end %Task Switch

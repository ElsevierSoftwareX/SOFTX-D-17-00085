% Tim Truster
% 10/20/2015
% 3D CZM element, elastic stiffness only

switch isw %Task Switch
    
    case 1
        
        if ndf > 3
            
            for i = 4:ndf
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
        
        Nmat = zeros(3,nst);
        
        ulres = reshape(ul,nst,1);
            
        if nel == 6
            linttw = 3;7;
            lintlw = 1;
            lint = linttw*lintlw;
            xlEdge = xl;
        elseif nel == 8
            lint = 4;
            xlEdge = xl;
        elseif nel == 18
            lint = 9;
            xlEdge = xl;
        elseif nel == 12
            linttw = 13;7;3;
            lintlw = 1;
            lint = linttw*lintlw;
            xlEdge = xl;
        else
            error('not implemented')
        end
        
        for ll = 1:lint
            
            if nel == 6
              [Wgt,ss] =  intpntw(ll,linttw,lintlw,1);
              [shlL,shld,shls,be] = shlw(ss,6,6,0,0);
              [~, ~, ~, ~, xsL] = shgw(xlEdge,6,shld,shls,nen,0,0,0);
            elseif nel == 8
                [Wgt,ss] =  intpntb(ll,lint,5);
                [shlL,shld,shls,be] = shlb(ss,8,8,0,0);
                [~, ~, ~, ~, xsL] = shgb(xlEdge,8,shld,shls,nen,0,0,0);
            elseif nel == 18
                [Wgt,ss] =  intpntb(ll,lint,5);
                [shlL,shld,shls,be] = shlbCZ(ss,18,18,0,0);
                [~, ~, ~, ~, xsL] = shgb(xlEdge,18,shld,shls,nel,0,0,0);
            elseif nel == 12
              [Wgt,ss] =  intpntw(ll,linttw,lintlw,1);
                [shlL,shld,shls,be] = shlwCZ(ss,12,12,0,0);
                [~, ~, ~, ~, xsL] = shgw(xlEdge,12,shld,shls,nel,0,0,0);
            end

            ss(3) = 1;
            
            if nel == 6
                [shlR,shld,shls,be] = shlw(ss,6,6,0,0);
            elseif nel == 8
                [shlR,shld,shls,be] = shlb(ss,8,8,0,0);
            elseif nel == 18
                [shlR,shld,shls,be] = shlbCZ(ss,18,18,0,0);
            elseif nel == 12
                [shlR,shld,shls,be] = shlwCZ(ss,12,12,0,0);
            end
            
            %Evaluate tangent and normal vectors
            t1 = [xsL(:,1); 0];
            [tm1, tu1] = VecNormalize(t1);
            t2 = [xsL(:,2); 0];
            [tm2, tu2] = VecNormalize(t2);
            t3 = VecCrossProd(t1,t2);
            [tm3, tu3] = VecNormalize(t3);
            nLx = tu3(1);
            nLy = tu3(2);
            nLz = tu3(3);
            nvect = [nLx 0 0 nLy 0   nLz 
                     0 nLy 0 nLx nLz 0 
                     0 0 nLz 0   nLy nLx];
            nvec = [nLx; nLy; nLz];
                    
            c1 = Wgt*tm3;
            
            if nel == 6
            for i = 1:3
                Nmat(1,(i-1)*ndf+1) = -shlL(i);
                Nmat(2,(i-1)*ndf+2) = -shlL(i);
                Nmat(3,(i-1)*ndf+3) = -shlL(i);
            end
            for i = 4:6
                Nmat(1,(i-1)*ndf+1) = shlR(i);
                Nmat(2,(i-1)*ndf+2) = shlR(i);
                Nmat(3,(i-1)*ndf+3) = shlR(i);
            end
            elseif nel == 8
            for i = 1:4
                Nmat(1,(i-1)*ndf+1) = -shlL(i);
                Nmat(2,(i-1)*ndf+2) = -shlL(i);
                Nmat(3,(i-1)*ndf+3) = -shlL(i);
            end
            for i = 5:8
                Nmat(1,(i-1)*ndf+1) = shlR(i);
                Nmat(2,(i-1)*ndf+2) = shlR(i);
                Nmat(3,(i-1)*ndf+3) = shlR(i);
            end
            elseif nel == 18
            for i = 1:9
                Nmat(1,(i-1)*ndf+1) = -shlL(i);
                Nmat(2,(i-1)*ndf+2) = -shlL(i);
                Nmat(3,(i-1)*ndf+3) = -shlL(i);
            end
            for i = 10:18
                Nmat(1,(i-1)*ndf+1) = shlR(i);
                Nmat(2,(i-1)*ndf+2) = shlR(i);
                Nmat(3,(i-1)*ndf+3) = shlR(i);
            end
            elseif nel == 12
            for i = 1:6
                Nmat(1,(i-1)*ndf+1) = -shlL(i);
                Nmat(2,(i-1)*ndf+2) = -shlL(i);
                Nmat(3,(i-1)*ndf+3) = -shlL(i);
            end
            for i = 7:12
                Nmat(1,(i-1)*ndf+1) = shlR(i);
                Nmat(2,(i-1)*ndf+2) = shlR(i);
                Nmat(3,(i-1)*ndf+3) = shlR(i);
            end
            end
            
            jumpu = Nmat*ulres;    %displacement jump
            normu = norm(jumpu);
            dn = jumpu'*nvec;
            ushear = jumpu - dn*nvec;
            Rmat = [nvec tu1(1:3)' tu2(1:3)']';
            ds1 = Rmat(2,1:3)*ushear;
            ds2 = Rmat(3,1:3)*ushear;
            ts1 = Kc*ds1;
            ts2 = Kc*ds2;
            tn = Kc*dn;
            Cnn = Kc;
            Css1 = Cnn;
            Css2 = Cnn;
            Cns = 0;
            tvec = Rmat'*[tn; ts1; ts2];
            Kmat = Rmat'*[Cnn 0 0; 0 Css1 0; 0 0 Css2]*Rmat;
            
            % Force terms
            ElemF = ElemF - c1*(Nmat'*tvec);

            % Penalty terms
            ElemK = ElemK + c1*(Nmat'*Kmat*Nmat);
            
        end %lint

    ElemK;
            
end %Task Switch

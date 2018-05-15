% Two dimenisional plane stress/strain element

PatchE = mateprop(1);
Patchv = mateprop(2);
thick = mateprop(3);
if ~exist('PSPS','var')
PSPS = 'n'; %plane stresS/straiN flag
end
if ~exist('iprob','var')
iprob = 0;
end

Bcol1 = [1; 3];
Bcol2 = [2; 3];
col1 = [1; 2];
col2 = [2; 1];

switch isw %Task Switch
    
    case 1
        
        if ndf > 2
            
            for i = 3:ndf
                lie(i,1) = 0;
            end
            
        end
        
        istv = 7; % number of stresses per node for post-processing
        iste = 7; % number of stresses per element
%%
    case 3

        ElemK = zeros(ndf*nel);
        ElemF = zeros(ndf*nel,1);
        Nmat = zeros(2,ndf*nel);
        Bmat = zeros(3,ndf*nel);

        % Load Gauss Points for quadrature
        if nel == 3
            lint = lintt3;%13;
        elseif nel == 4
            lint = lintq4;
        elseif nel == 6
            lint = lintt6;%13;
        elseif nel == 9
            lint = lintq9;
        end
 
        lam = Patchv*PatchE/((1+Patchv)*(1-2*Patchv));
        mu = PatchE/(2*(1+Patchv));
        
        cvec = zeros(3,1); %temperature vector, see Hughes book
        if PSPS == 'n'
        Dmat = mu*diag([2 2 1]) + lam*[1; 1; 0]*[1 1 0];
        else
        Dmat = PatchE/(1-Patchv^2)*[1      Patchv  0
                                  Patchv  1      0
                                  0      0      (1-Patchv)/2];
        end

        der = 0;
        bf = 0;
        ib = 0;
        
        ulres = reshape(ul,ndf*nen,1);
        
        for je = 1:lint

            if nel == 3 || nel == 6
                [Wgt,litr,lits] = intpntt(je,lint,ib);
                [shl,shld,shls,be] = shlt(litr,lits,nel,nel,der,bf);
                [shg, shgs, Jdet, be, xs] = shgt(xl,nel,shld,shls,nen,bf,der,be);
            elseif nel == 4 || nel == 9
                [Wgt,litr,lits] = intpntq(je,lint,ib);
                [shl,shld,shls,be] = shlq(litr,lits,nel,nel,der,bf);
                [shg, shgs, Jdet, be, xs] = shgq(xl,nel,shld,shls,nen,bf,der,be);
            end
                    
            c1 = Wgt*Jdet*thick;
            
            % Form B matrix
            for ie = 1:nel
                
              Nmat(1,(ie-1)*ndf+1) = shl(ie);
              Nmat(2,(ie-1)*ndf+2) = shl(ie);
                
              Bmat(Bcol1,(ie-1)*ndf+1) = shg(ie,col1);
              Bmat(Bcol2,(ie-1)*ndf+2) = shg(ie,col2);
                 
            end
            
            xint = xl(:,1:nel)*shl;
            
            sigma = Dmat*(Bmat*ulres(1:nel*ndf) - cvec);
            
            ElemF = ElemF - c1*Bmat'*sigma;
            ElemK = ElemK + c1*Bmat'*Dmat*Bmat;
            
        end %je
ElemK;
        
%%
    case -1 % boundary tractions
        
        ElemF = zeros(nst,1);
        
        % Reorder nodes for corresponding face of integration
        SurfOrientEtoS

        % Determine bounds of integration
        
        if nel == 4 || nel == 9
            
        dr = 2;
        ro = -1;
        
        % Upper Limit
%         if nodeA == ElemFlag(2)
            eR2 = 1;
%         else %
%             eR2 = 0;
%         end
        % Lower Limit
%         if nodeB == ElemFlag(1)
            eR1 = -1;
%         else %nodeA == ElemFlag(5)
%             eR1 = 0;
%         end
        
        elseif nel == 3 || nel == 6
            
        dr = 1;
        ro = 0;
            
        % Upper Limit
%         if nodeA == ElemFlag(2)
            eR2 = 1;
%         else %nodeA == ElemFlagR(5)
%             eR2 = 1/2;
%         end
        % Lower Limit
%         if nodeB == ElemFlag(1)
            eR1 = 0;
%         else %nodeA == ElemFlag(5)
%             eR1 = 1/2;
%         end
        
        end
        
        % Set jacobian for integration space
        drdr = (eR2 - eR1)/dr;
        
        lint = 4;
%         % Load Gauss Points for quadrature
%         if enrich == 1
%             [rlist, rWgts, rnum] = GaussPoints(pr+2);
%             slist = -1;
%             sWgts = 1;
%             snum = 1;
%         else
%             [rlist, rWgts, rnum] = GaussPoints(pr+1);
%             slist = -1;
%             sWgts = 1;
%             snum = 1;
%         end

%         lamda = Patchv*PatchE/((1+Patchv)*(1-2*Patchv));
%         mu = PatchE/(2*(1+Patchv));
%         thick = 1;
        ideriv = 0;
        der = 0;
        bf = 0;

        Nmat = zeros(2,ndf*nel);
        
        for je = 1:lint

            if nel == 3 || nel == 6
                [Wgt,r,s] = intpntt(je,lint,1);
            else %if nel == 4
                [Wgt,r,s] = intpntq(je,lint,1);
            end
            r = drdr*(r-ro)+eR1;

            if nel == 3 || nel == 6
                [shl,shld,shls,be] = shlt(r,s,nel,nel,der,bf);
                [shg, shgs, Jdet, be, xs] = shgt(xl,nel,shld,shls,nen,bf,der,be);
            elseif nel == 4 || nel == 9
                [shl,shld,shls,be] = shlq(r,s,nel,nel,der,bf);
                [shg, shgs, Jdet, be, xs] = shgq(xl,nel,shld,shls,nen,bf,der,be);
            end
                    
            %Evaluate tangent and normal vectors
            t1 = [xs(:,1); 0];
            [tm1, tu1] = VecNormalize(t1);
            t2 = [0; 0; 1];
            tm2 = 1;
            tu2 = t2';
            t3 = VecCrossProd(t1,t2);
            [tm3, tu3] = VecNormalize(t3);
            Traction = zeros(1,2);
            
            if edge < 0 % negative edge denotes pressure
                pressur = -traction(1); % pressure is defined positive in compression
                Traction = pressur*tu3(1:2);
            else
                Traction = traction(1:2);
            end
            
            c1 = Wgt*tm3*drdr*thick;
            
            for ie = 1:nel
                
              Nmat(1,(ie-1)*ndf+1) = shl(ie);
              Nmat(2,(ie-1)*ndf+2) = shl(ie);
                 
            end
            
            ElemF = ElemF + c1*Nmat'*Traction';

        end %ie
        
        % Reorder nodes back to the orientation of the element
        SurfOrientStoE
        ElemF(1:ndf*nel) = ElemF(ilist2);

%%        
    case 25 %Stress Projection

        ElemS = zeros(nel,npstr+1);
        ElemS2 = zeros(nel,npstr);
        stresID = [1 2 3 0 1 3];

        lam = Patchv*PatchE/((1+Patchv)*(1-2*Patchv));
        mu = PatchE/(2*(1+Patchv));
        thick = 1;
        fbx = 0;
        fby = 0;
        fbz = 0;
        if PSPS == 'n'
        Dmat = mu*diag([2 2 1]) + lam*[1; 1; 0]*[1 1 0];
        else
        Dmat = PatchE/(1-Patchv^2)*[1      Patchv  0
                                  Patchv  1      0
                                  0      0      (1-Patchv)/2];
        end
        Nmat = zeros(2,ndf*nel);
        Bmat = zeros(3,ndf*nel);
        I1 = [1; 1; 0];
        
        % Load Guass Integration Points

        if nel == 3
            lint = 1;
            nint = 1;
        elseif nel == 4
%             lint = 4;
            lint = 4;
            nint = 1;
        elseif nel == 6
            lint = 7;
            nint = 3;
        else
            lint = 9;
            nint = 4;
        end
        
        der = 0;
        bf = 0;
        ib = 0;
        
        ulres = reshape(ul,nst,1);

        %Stress Loop
        for ll = 1:nint

            %Evaluate first derivatives of basis functions at int. point
            if nel == 3 || nel == 6
              [w,litr,lits] =  intpntt(ll,nint,ib);
              [shl,shld,shls,be] = shlt(litr,lits,nel,nel,der,bf);
              [shg,shgs,Jdet,be] = shgt(xl,nel,shld,shls,nel,bf,der,be);
            else
              [w,litr,lits] =  intpntq(ll,nint,ib);
              [shl,shld,shls,be] = shlq(litr,lits,nel,nel,der,bf);
              [shg,shgs,Jdet,be] = shgq(xl,nel,shld,shls,nel,bf,der,be);
            end
            
            % Form B matrix
            for ie = 1:nel
              
              Bmat(Bcol1,(ie-1)*ndf+1) = shg(ie,col1);
              Bmat(Bcol2,(ie-1)*ndf+2) = shg(ie,col2);
                 
            end
            
            epsil = Bmat*ulres(1:ndf*nel);
            sigma = Dmat*epsil;
            
            for stres = 1:npstr
            
            if stres <= 3 % stress components
                sigmas = sigma(stresID(stres));
            elseif stres >= 5
                if stres <= 6 % principal stresses
                    if PSPS == 'n'
                        sigz = lam*(epsil(1)+epsil(2));
                    else
                        sigz = 0;
                    end
                    sigma2 = [sigma(1) sigma(3) 0; sigma(3) sigma(2) 0; 0 0 sigz];
                    psig = eig(sigma2);
                    sigmas = psig(stresID(stres));
                else % hydrostatic stress
                    if PSPS == 'n'
                        sigz = lam*(epsil(1)+epsil(2));
                    else
                        sigz = 0;
                    end
                    sigmas = 1/3*(sigma'*I1 + sigz);
                end
            else % von Mises stress
                if PSPS == 'n'
                    sigz = lam*(epsil(1)+epsil(2));
                else
                    sigz = 0;
                end
                trs = sigma'*I1 + sigz;
                dsig = sigma - 1/3*trs*I1;
                sigmas = sqrt(3/2*(dsig'*dsig));
            end
            
            ElemS2(ll,stres) = sigmas;
            
            end

        end %je
        
        % interpolate stress at nodes
        if nel == 3
            plist = [0 1 0
                     0 0 1];
        elseif nel == 4
            plist = [-1 1 1 -1
                     -1 -1 1 1];
        elseif nel == 6
            plist = [-1/3 5/3 -1/3 2/3 2/3 -1/3
                     -1/3 -1/3 5/3 -1/3 2/3 2/3];
        else
            sqr3 = sqrt(3);
            plist = [-sqr3 sqr3 sqr3 -sqr3 0 sqr3 0 -sqr3 0
                     -sqr3 -sqr3 sqr3 sqr3 -sqr3 0 sqr3 0 0];
        end
        
        for ll = 1:nelS
            
            r = plist(1,ll);
            s = plist(2,ll);
            shpS = sshp2d(r,s,nint);
            
%             for stres = 1:npstr
%                 
%                 sigmas = ElemS2(1:nint,stres)'*shpS;
%                 ElemS(ll,stres) = sigmas;
%                 
%             end
            ElemS(ll,1:npstr) = (ElemS2(1:nint,:)'*shpS)';
            
        end
        
%         %Integration Loop
%         Vol = 0;
%         for ll = 1:lint
% 
%             %Evaluate first derivatives of basis functions at int. point
%             if nel == 3 || nel == 6
%               [Wgt,litr,lits] =  intpntt(ll,lint,ib);
%               [shl,shld,shls,be] = shlt(litr,lits,nel,nel,der,bf);
%               [Qxy, shgs, Jdet,be] = shgt(xl+ul(1:2,:),nel,shld,shls,nel,bf,der,be);
%             else
%               [Wgt,litr,lits] =  intpntq(ll,lint,ib);
%               [shl,shld,shls,be] = shlq(litr,lits,nel,nel,der,bf);
%               [Qxy, shgs, Jdet,be] = shgq(xl+ul(1:2,:),nel,shld,shls,nel,bf,der,be);
%             end
% 
%             w = Wgt*Jdet*thick;
%             
%             Vol = Vol + w;
% 
%         end %je

        for i = 1:nel
        ElemS(i,npstr+1) = 1; % use this for simple average Vol; % use this for weighted average 
        end
        
    case 26
        
        ElemS = zeros(npstr,1);
        stresID = [1 2 3 0 1 3];

        lam = Patchv*PatchE/((1+Patchv)*(1-2*Patchv));
        mu = PatchE/(2*(1+Patchv));
        thick = 1;
        fbx = 0;
        fby = 0;
        fbz = 0;
        if PSPS == 'n'
        Dmat = mu*diag([2 2 1]) + lam*[1; 1; 0]*[1 1 0];
        else
        Dmat = PatchE/(1-Patchv^2)*[1      Patchv  0
                                  Patchv  1      0
                                  0      0      (1-Patchv)/2];
        end
        Nmat = zeros(2,ndf*nel);
        Bmat = zeros(3,ndf*nel);
        I1 = [1; 1; 0];
        
        % Load Guass Integration Points

        if nel == 3
            lint = 1;
            nint = 1;
        elseif nel == 4
%             lint = 4;
            lint = 4;
            nint = 1;
        elseif nel == 6
            lint = 7;
            nint = 3;
        else
            lint = 9;
            nint = 4;
        end
        
        der = 0;
        bf = 0;
        ib = 0;
        
        ulres = reshape(ul,nst,1);

        %Stress Loop
        ll = 1;
%         for ll = 1:nint

            %Evaluate first derivatives of basis functions at int. point
            if nel == 3 || nel == 6
              [w,litr,lits] =  intpntt(ll,ll,ib);
              [shl,shld,shls,be] = shlt(litr,lits,nel,nel,der,bf);
              [shg,shgs,Jdet,be] = shgt(xl,nel,shld,shls,nel,bf,der,be);
            else
              [w,litr,lits] =  intpntq(ll,ll,ib);
              [shl,shld,shls,be] = shlq(litr,lits,nel,nel,der,bf);
              [shg,shgs,Jdet,be] = shgq(xl,nel,shld,shls,nel,bf,der,be);
            end
            
            % Form B matrix
            for ie = 1:nel
              
              Bmat(Bcol1,(ie-1)*ndf+1) = shg(ie,col1);
              Bmat(Bcol2,(ie-1)*ndf+2) = shg(ie,col2);
                 
            end
            
            epsil = Bmat*ulres(1:ndf*nel);
            sigma = Dmat*epsil;
            
            for stres = 1:npstr
            
            if stres <= 3 % stress components
                sigmas = sigma(stresID(stres));
            elseif stres >= 5
                if stres <= 6 % principal stresses
                    if PSPS == 'n'
                        sigz = lam*(epsil(1)+epsil(2));
                    else
                        sigz = 0;
                    end
                    sigma2 = [sigma(1) sigma(3) 0; sigma(3) sigma(2) 0; 0 0 sigz];
                    psig = eig(sigma2);
                    sigmas = psig(stresID(stres));
                else % hydrostatic stress
                    if PSPS == 'n'
                        sigz = lam*(epsil(1)+epsil(2));
                    else
                        sigz = 0;
                    end
                    sigmas = 1/3*(sigma'*I1 + sigz);
                end
            else % von Mises stress
                if PSPS == 'n'
                    sigz = lam*(epsil(1)+epsil(2));
                else
                    sigz = 0;
                end
                trs = sigma'*I1 + sigz;
                dsig = sigma - 1/3*trs*I1;
                sigmas = sqrt(3/2*(dsig'*dsig));
            end
            
            ElemS(stres) = sigmas;
            
            end

%         end %je
        
end %Task Switch


if isw ~= 1
CGtoDGarrays
nelLP = nelL;
nelRP = nelR;

inter = elem - (numel - numSI);
nodeAR = -1;%SurfacesI(inter,1);
nodeBR = -1;%SurfacesI(inter,2);
nodeAL = -1;%SurfacesI(inter,3);
nodeBL = -1;%SurfacesI(inter,4);
end


% Tim Truster
% 10/15/13
% DG for elasticity problem in 3D with conforming interfaces.
% The DG element input should simply be ix = [ixL ixR maDG] with ixL and
% ixR the connectivity from FormDG.

nitvms = 1;
if nitvms == 1 %VMS
pencoeff = 4;1;
elseif nitvms == 2 %Nitsche
pencoeff = 1;4;2;
else %RFB
pencoeff = 1;4;2;
end

Bcol1 = [1; 4; 6];
Bcol2 = [2; 4; 5];
Bcol3 = [3; 5; 6];
col1 = [1; 2; 3];
col2 = [2; 1; 3];
col3 = [3; 2; 1];

switch isw %Task Switch
    
    case 1
        
        if ndf > 3
            
            for i = 4:ndf
                lie(i,1) = 0;
            end
            
        end
%%
    case {3,6,21} %interface stiffness
        
        ElemKRR = zeros(nstR,nstR);
        ElemKRL = zeros(nstR,nstL);
        ElemKLR = zeros(nstL,nstR);
        ElemKLL = zeros(nstL,nstL);
        ElemFR = zeros(nstR,1);
        ElemFL = zeros(nstL,1);
        t1 = zeros(3,1);
        t2 = t1;
        t3 = t1;
        
        bf1 = 0;
        bf2 = 0;
        
        ElemEL = matepropL(1);
        ElemvL = matepropL(2);
        ElemER = matepropR(1);
        ElemvR = matepropR(2);
        lamdaR = ElemvR*ElemER/((1+ElemvR)*(1-2*ElemvR));
        muR = ElemER/(2*(1+ElemvR));
        lamdaL = ElemvL*ElemEL/((1+ElemvL)*(1-2*ElemvL));
        muL = ElemEL/(2*(1+ElemvL));
        DmatR = muR*diag([2 2 2 1 1 1]) + lamdaR*[1; 1; 1; 0; 0; 0]*[1 1 1 0 0 0];
        DmatL = muL*diag([2 2 2 1 1 1]) + lamdaL*[1; 1; 1; 0; 0; 0]*[1 1 1 0 0 0];
        
        NmatL = zeros(3,nstL);
        BmatL = zeros(6,nstL);
        bnAdN1 = zeros(6,nstL);
        N1 = zeros(3,nstL);
        NmatR = zeros(3,nstR);
        BmatR = zeros(6,nstR);
        bnAdN2 = zeros(6,nstR);
        N2 = zeros(3,nstR);
        
        ulresL = reshape(ulL,ndf*nelL,1);
        ulresR = reshape(ulR,ndf*nelR,1);
        
        if nelL == 4
            lint = 3;11;5;16;
        elseif nelL == 8
            lint = 4;100;4;8;
        elseif nelL == 10
            lint = 13;14;
%             lint = 27;
        elseif nelL == 27
            lint = 9;
        else
            error('DG wedge not yet implemented')
        end

        der = 0;
        bf = 0;
        ib = 5;   

        % Compute the tau integrals
        [tauL,intbL,volL] = TauE1_3d(xlL,DmatL,nelL);
        [tauR,intbR,volR] = TauE1_3d(xlR,DmatR,nelR);


        % Modifications to tau
        if exist('diagt','var') && diagt == 1 % make tauL and tauR diagonal
            if exist('scalt','var') && scalt == 1 % use a scalar of tau times the identity
                if exist('minmaxt','var') && minmaxt == -1 % minimum entry
                    tau = diag(inv(tauL));
                    tau = min(tau)*ones(2,1);
                    tauL = inv(diag(tau));
                    tau = diag(inv(tauR));
                    tau = min(tau)*ones(2,1);
                    tauR = inv(diag(tau));
                else %if minmaxt == 1 % maximum entry
                    tau = diag(inv(tauL));
                    tau = max(tau)*ones(2,1);
                    tauL = inv(diag(tau));
                    tau = diag(inv(tauR));
                    tau = max(tau)*ones(2,1);
                    tauR = inv(diag(tau));
                end
            else % diagonal only
                tauL = inv(diag(diag(inv(tauL))));
                tauR = inv(diag(diag(inv(tauR))));
            end
        end
        
        if exist('equat','var') && equat == 1 % make tauL = tauR
            if exist('scalt','var') && scalt == 1 % use a scalar of tau times the identity
                if exist('minmaxt','var') && minmaxt == -1 % minimum entry
                    tau = diag(inv(tauL));
                    tau = min(tau)*ones(2,1);
                    tauL = inv(diag(tau));
                    tau = diag(inv(tauR));
                    tau = min(tau)*ones(2,1);
                    tauR = inv(diag(tau));
                else %if minmaxt == 1 % maximum entry
                    tau = diag(inv(tauL));
                    tau = max(tau)*ones(2,1);
                    tauL = inv(diag(tau));
                    tau = diag(inv(tauR));
                    tau = max(tau)*ones(2,1);
                    tauR = inv(diag(tau));
                end
            end
%             else % equal only
                tau = inv(tauL + tauR);
                tauL = 1/2*(tauL*tau*tauR + tauR*tau*tauL);
                tauR = tauL;
%             end
        end

        ebL = 0;
        ebR = 0;
        intedge = 0;
        
        for ie = 1:lint            
% For separate bubble types on T and Q
           if nelL == 4 || nelL == 10
                [Wgt,ss] =  int3d_t(ie,lint,ib);
                ebeL = facebubbleT(ss,nelL);
                [shlL,shldL,shls,be] = shltt(ss,nelL,nelL,0,0);
           else
                [Wgt,ss] = intpntb(ie,lint,ib);
                [shlL,shldL,shls,be] = shlb(ss,nelL,nelL,0,0);
                ebeL = facebubbleQ(ss,nelL);
           end
                
           if nelR == 4 || nelR == 10
                [Wgt,ss] =  int3d_t(ie,lint,ib);
                ebeR = facebubbleT(ss,nelR);
           else
                [Wgt,ss] = intpntb(ie,lint,ib);
                ebeR = facebubbleQ(ss,nelR);
           end           
            
           if nelL == 4 || nelL == 10
                [Wgt,ss] =  int3d_t(ie,lint,ib);
                [shlL,shldL,shls,be] = shltt(ss,nelL,nelL,0,0);
                [PxyL,shgsL,JdetL,bubbleL,XsL] = shgtt(xlL(:,1:nelL),nelL,shldL,shls,nen,0,0,be);               
           else
                [Wgt,ss] = intpntb(ie,lint,ib);
                [shlL,shldL,shls,be] = shlb(ss,nelL,nelL,0,0);
                [PxyL,shgsL,JdetL,bubbleL,XsL] = shgb(xlL(:,1:nelL),nelL,shldL,shls,nen,0,0,be); 
           end
                    
            %Evaluate tangent and normal vectors
            T1L = XsL(:,1);
            [Tm1L, Tu1L] = VecNormalize(T1L);
            T2L = XsL(:,2);
            [Tm2L, Tu2L] = VecNormalize(T2L);
            T3L = VecCrossProd(T1L,T2L);
            [Tm3L, Tu3L] = VecNormalize(T3L);

            C1L = Wgt*Tm3L;
                
            ebL = ebL + C1L*ebeL;
            ebR = ebR + C1L*ebeR;
            intedge = intedge + C1L;

        end   
        
        if nitvms == 1
        % VMS
        edgeK = tauL*ebL^2 + tauR*ebR^2;
        gamL = ebL^2*(edgeK\tauL);
        gamR = ebR^2*(edgeK\tauR);
        ep = pencoeff*intedge*inv(edgeK); %#ok<MINV>
        elseif nitvms == 2
        % Nitsche
        h = 2/(intedge/volR + intedge/volL);
        gamL = 1/2*eye(3);
        gamR = 1/2*eye(3);
        ep = 1000;pencoeff*eye(3)*max(muL,muR)/h;
        end
        
   
        for l = 1:lint %integrate on left domain

                % Evaluate  basis functions at integration points
                if nelL == 4 || nelL == 10
                  [Wgt,ss] = int3d_t(l,lint,ib);
                  [shlL,shldL,shls,be] = shltt(ss,nelL,nelL,0,0);                
                  [QxyL,shgsL,JdetL,bubbleL,xsL] = shgtt(xlL(:,1:nelL),nelL,shldL,shls,nen,0,0,be);
                else
                  [Wgt,ss] = intpntb(l,lint,ib);
                  [shlL,shldL,shls,be] = shlb(ss,nelL,nelL,0,0); 
                  [QxyL,shgsL,JdetL,bubbleL,xsL] = shgb(xlL(:,1:nelL),nelL,shldL,shls,nen,0,0,be);
                end

                %Physical location of int pt
                xint = xlL(1,:)*shlL;
                yint = xlL(2,:)*shlL;
                zint = xlL(3,:)*shlL;

                xi = POU_Coord3(xint,yint,zint,xlR,1,nelR);   %Get the kesi eta in the right hand side
                rR = xi(1);
                sR = xi(2);
                tR = xi(3);

                % Evaluate  basis functions at integration points
                if nelR == 4 || nelR == 10
                  [shlR,shldR,shls,be] = shltt([rR sR tR],nelR,nelR,0,0);                
                  [QxyR,shgsR,JdetR,bubbleR,xsR] = shgtt(xlR(:,1:nelR),nelR,shldR,shls,nen,0,0,be);
                  
                else
                  [shlR,shldR,shls,be] = shlb([rR sR tR],nelR,nelR,0,0); 
                  [QxyR,shgsR,JdetR,bubbleR,xsR] = shgb(xlR(:,1:nelR),nelR,shldR,shls,nen,0,0,be);
                end

                %Evaluate tangent and normal vectors
                t1L = xsL(:,1);
                [tm1L, tu1L] = VecNormalize(t1L);
                t2L = xsL(:,2);
                [tm2L, tu2L] = VecNormalize(t2L);
                t3L = VecCrossProd(t1L,t2L);
                [tm3L, tu3L] = VecNormalize(t3L);
                t1R = xsR(:,1);
                [tm1R, tu1R] = VecNormalize(t1R);
                t2R = xsR(:,2);
                [tm2R, tu2R] = VecNormalize(t2R);
                t3R = VecCrossProd(t1R,t2R);
                [tm3R, tu3R] = VecNormalize(t3R);
                c1 = Wgt*tm3L;
                %normal vectors
                nLx = -tu3L(1);
                nLy = -tu3L(2);
                nLz = -tu3L(3);
                nRx = -tu3R(1);
                nRy = -tu3R(2);
                nRz = -tu3R(3);
                nvect = [nLx 0 0 nLy 0   nLz 
                         0 nLy 0 nLx nLz 0 
                         0 0 nLz 0   nLy nLx];
                nvec = [nLx; nLy; nLz];

                for i = 1:nelL
                    NmatL(1,(i-1)*ndf+1) = shlL(i);
                    NmatL(2,(i-1)*ndf+2) = shlL(i);
                    NmatL(3,(i-1)*ndf+3) = shlL(i);
                    BmatL(Bcol1,(i-1)*ndf+1) = QxyL(i,col1);
                    BmatL(Bcol2,(i-1)*ndf+2) = QxyL(i,col2);
                    BmatL(Bcol3,(i-1)*ndf+3) = QxyL(i,col3);
                end

                for i = 1:nelR
                    NmatR(1,(i-1)*ndf+1) = shlR(i);
                    NmatR(2,(i-1)*ndf+2) = shlR(i);
                    NmatR(3,(i-1)*ndf+3) = shlR(i);
                    BmatR(Bcol1,(i-1)*ndf+1) = QxyR(i,col1);
                    BmatR(Bcol2,(i-1)*ndf+2) = QxyR(i,col2);
                    BmatR(Bcol3,(i-1)*ndf+3) = QxyR(i,col3);
                end

                bnAdN1 = gamL*nvect*DmatL*BmatL;
                bnAdN2 = gamR*nvect*DmatR*BmatR;

                xint = xlL*shlL;

                tvtr = (bnAdN1*ulresL + bnAdN2*ulresR); %average stress
                jumpu = NmatR*ulresR - NmatL*ulresL;        %displacement jump

                % Not needed for linear problems
                ElemFL = ElemFL - c1*( - NmatL'*(tvtr + ep*jumpu) + bnAdN1'*jumpu);
                ElemFR = ElemFR - c1*( + NmatR'*(tvtr + ep*jumpu) + bnAdN2'*jumpu);

                ElemKLL = ElemKLL - c1*NmatL'*bnAdN1;
                ElemKLR = ElemKLR - c1*NmatL'*bnAdN2;
                ElemKRL = ElemKRL + c1*NmatR'*bnAdN1;
                ElemKRR = ElemKRR + c1*NmatR'*bnAdN2;

                ElemKLL = ElemKLL - c1*bnAdN1'*NmatL;
                ElemKLR = ElemKLR + c1*bnAdN1'*NmatR;
                ElemKRL = ElemKRL - c1*bnAdN2'*NmatL;
                ElemKRR = ElemKRR + c1*bnAdN2'*NmatR;

                ElemKLL = ElemKLL + c1*(NmatL'*ep*NmatL);
                ElemKLR = ElemKLR - c1*(NmatL'*ep*NmatR);
                ElemKRL = ElemKRL - c1*(NmatR'*ep*NmatL);
                ElemKRR = ElemKRR + c1*(NmatR'*ep*NmatR);
        
        end
% ElemKLL
            ElemK = [ElemKLL ElemKLR; ElemKRL ElemKRR];
            ElemF = [ElemFL; ElemFR];

%%        
    case 25 %Stress Projection2
        
end %Task Switch

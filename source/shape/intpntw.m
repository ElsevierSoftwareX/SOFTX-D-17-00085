function [w,s] = intpntw(l,lintt,lintl,ib)
% 10/16/2013
% Tim Truster
% C-----------------------------------------------------------------------
% C      Purpose: Gauss quadrature for 3-d Wedge element
% C      Inputs:
% C         ll     - Number of points/direction
% C      Outputs:
% C         lintt  - Total number of quadrature points (triangle)
% C         lintl  - Total number of quadrature points (line)
% C         s(4,*) - Gauss points (1-3) and weights (4)
% Done in a tensor-product fashion
% C-----------------------------------------------------------------------
%       implicit  none
% 
%       integer   ll,lint, i,j,k,n
%       real*8    s(4,125),gauss(10),weight(10)
   s = zeros(3,1);

   if ib == 0
   
        j = ceil(l/lintt); % 1D integration pt
        k = (l-(j-1)*lintt); % triangle integration pt
        % triangle quadrature
        [wt,c1,c2] = intpntt(k,lintt,ib);
        % 1D quadrature
        sw = int1d(lintl);
        s(1)=c1;
        s(2)=c2;
        s(3)=sw(1,j);
        w=wt*sw(2,j);

   else %if ib == 1

          % Assume bottom triangle integration
          
        % triangle quadrature
        [wt,c1,c2] = intpntt(l,lintt,0);
        s(1)=c1;
        s(2)=c2;
        s(3)=-1.d0;
        w=wt;

   end %if
   
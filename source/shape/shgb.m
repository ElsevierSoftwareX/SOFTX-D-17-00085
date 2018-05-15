function [shgd,shgs,xsj,bubble,sx] = shgb(xl,nel,shld,shls,nen,bf,der,bubble)
%         IMPLICIT DOUBLE PRECISION (A-H,O-Z)
% c      3 dimensional 8 noded element + bubble point
% c      By Kaiming Xia 09/20/2001
% c         Second derivatives of shape functions for cartesian coordinates
% c         By Kaiming Xia 11/03/2001
% c         Fixed by Tim Truster 01/03/2012
% c      Purpose: Compute 3-d isoparametric 8-node element shape
% c               functions and first and second of their derivatives w/r x,y,z
% c      Inputs:
% c         ss(3)     - Natural coordinates of point
% c         xl(ndm,*) - Nodal coordinates for element
% c         ndm       - Spatial dimension of mesh
% c             ideriv          - Flag for activation of second derivatives (default=0
% c                     don't compute second derivative
% c      Outputs:
% c         xsj       - Jacobian determinant at point
% c         shp(4,*)  - Shape functions and derivatives at local point
% c                     shpg(1,i) = dN_i/dx
% c                     shpg(2,i) = dN_i/dy
% c                     shpg(3,i) = dN_i/dz
% c                     shp(4,i) =  N_i
% c                     shp2(1,i) = d^2N_i/dx^2
% c                     shp2(2,i) = d^2N_i/dy^2
% c                     shp2(3,i) = d^2N_i/dz^2
% c                     shp2(4,i) = d^2N_i/dxy
% c                     shp2(5,i) = d^2N_i/dyz
% c                     shp2(6,i) = d^2N_i/dzx
% c-----[--.----+----.----+----.-----------------------------------------]
%       DIMENSION c1(6,3),tc(6,3),tcj(6,3),at1(6),at2(6)
%         DIMENSION t2(6,6),cartd1(4,nel),cartd2(6,nel),shp2(6,nel)
%       DIMENSION  ss(3),shp(4,nel),xl(ndm,nel-1),xs(3,3),ad(3,3)

%    c1 = zeros(6,3);
%    tc = zeros(6,3);
%    tcj = zeros(6,3);
%    at1 = zeros(6,1);
%    at2 = zeros(6,1);
   t2 = zeros(6,6);
%    shg = zeros(nel,3);
   shgs = zeros(nel,6);
%    xs = zeros(3,3);
%    sx = zeros(3,3);
   ad = zeros(3,3);

% c compute jacobian transformation

%         for j=1:3
%         for i=1:3
% %           xs(i,j)=0.d0
% %           c1(i,j)=0.d0
%             for inode=1:nel
%               xs(i,j)=xs(i,j)+shl(i,inode)*xl(j,inode);
%               c1(i,j)=c1(i,j)+shls(i,inode)*xl(j,inode);
%             end
%         end
%         end
        sx = xl(:,1:nel)*shld;

        if der == 1
%         for i=4:6
%           for j=1:3
% %             c1(i,j)=0.d0
%             for inode=1:nel
%               c1(i,j)=c1(i,j)+shls(i,inode)*xl(j,inode);
%             end
%           end
%         end
      c1 = (xl(:,1:nel)*shls)';
        end


% c below is to calculate determinant and inverswe of jacobian matrix
% c
% c     Compute adjoint to jacobian

      ad(1,1) = sx(2,2)*sx(3,3) - sx(2,3)*sx(3,2);
      ad(1,2) = sx(3,2)*sx(1,3) - sx(3,3)*sx(1,2);
      ad(1,3) = sx(1,2)*sx(2,3) - sx(1,3)*sx(2,2);
      ad(2,1) = sx(2,3)*sx(3,1) - sx(2,1)*sx(3,3);
      ad(2,2) = sx(3,3)*sx(1,1) - sx(3,1)*sx(1,3);
      ad(2,3) = sx(1,3)*sx(2,1) - sx(1,1)*sx(2,3);
      ad(3,1) = sx(2,1)*sx(3,2) - sx(2,2)*sx(3,1);
      ad(3,2) = sx(3,1)*sx(1,2) - sx(3,2)*sx(1,1);
      ad(3,3) = sx(1,1)*sx(2,2) - sx(1,2)*sx(2,1);

% c     Compute determinant of jacobian

      xsj  = sx(1,1)*ad(1,1) + sx(1,2)*ad(2,1) + sx(1,3)*ad(3,1);
% C        write(30,*) 'xsj=',xsj
%         if(xsj.lt.0.d0) stop
      rxsj = 1.d0/xsj;

% c     Compute jacobian inverse

%       for j = 1:3
%         for i = 1:3
%           sx(i,j) = ad(i,j)*rxsj;
%         end
%       end
      xs = ad*rxsj;

% c     Compute derivatives with repect to global coords.

%       for k = 1:nel
%         d1 = shl(1,k)*sx(1,1) + shl(2,k)*sx(1,2) + shl(3,k)*sx(1,3);
%         d2 = shl(1,k)*sx(2,1) + shl(2,k)*sx(2,2) + shl(3,k)*sx(2,3);
%         d3 = shl(1,k)*sx(3,1) + shl(2,k)*sx(3,2) + shl(3,k)*sx(3,3);
%         shg(1,k) = d1;
%         shg(2,k) = d2;
%         shg(3,k) = d3;
%         shg(4,k)=shl(4,k);
%       end
        shgd = shld*xs; 
      
      if bf == 1
%         d1 = bubble(1)*sx(1,1) + bubble(2)*sx(1,2) + bubble(3)*sx(1,3);
%         d2 = bubble(1)*sx(2,1) + bubble(2)*sx(2,2) + bubble(3)*sx(2,3);
%         d3 = bubble(1)*sx(3,1) + bubble(2)*sx(3,2) + bubble(3)*sx(3,3);
%         bubble(1) = d1;
%         bubble(2) = d2;
%         bubble(3) = d3;
%         bubble(4)=bubble(4);
        bubble(1:3) = bubble(1:3)*xs;
      end 

% c     Initialize second derivatives with respect to global coords.
%       do n=1,nel
%           do i=1,6
%             shgs(i,n)=0.0d0
%           end do
%         end do

                if der == 1
xs = xs'; % Fixed 1/3/2012 to match Kaiming; gives correct 3D bar results
% C        Below is to calculate second derivative of shape functions
% 
% C        Calculate T2 matrix
        t2(1,1)=xs(1,1)^2;
        t2(2,1)=xs(2,1)^2;
        t2(3,1)=xs(3,1)^2;
        t2(4,1)=xs(1,1)*xs(2,1);
        t2(5,1)=xs(2,1)*xs(3,1);
        t2(6,1)=xs(1,1)*xs(3,1);

        t2(1,2)=xs(1,2)^2;
        t2(2,2)=xs(2,2)^2;
        t2(3,2)=xs(3,2)^2;
        t2(4,2)=xs(1,2)*xs(2,2);
        t2(5,2)=xs(2,2)*xs(3,2);
        t2(6,2)=xs(1,2)*xs(3,2);

        t2(1,3)=xs(1,3)^2;
        t2(2,3)=xs(2,3)^2;
        t2(3,3)=xs(3,3)^2;
        t2(4,3)=xs(1,3)*xs(2,3);
        t2(5,3)=xs(2,3)*xs(3,3);
        t2(6,3)=xs(1,3)*xs(3,3);

        t2(1,4)=2.d0*xs(1,1)*xs(1,2);
        t2(2,4)=2.d0*xs(2,1)*xs(2,2);
        t2(3,4)=2.d0*xs(3,1)*xs(3,2);
        t2(4,4)=xs(1,1)*xs(2,2)+xs(1,2)*xs(2,1);
        t2(5,4)=xs(2,1)*xs(3,2)+xs(2,2)*xs(3,1);
        t2(6,4)=xs(1,1)*xs(3,2)+xs(1,2)*xs(3,1);

        t2(1,5)=2.d0*xs(1,2)*xs(1,3);
        t2(2,5)=2.d0*xs(2,2)*xs(2,3);
        t2(3,5)=2.d0*xs(3,2)*xs(3,3);
        t2(4,5)=xs(1,2)*xs(2,3)+xs(1,3)*xs(2,2);
        t2(5,5)=xs(2,2)*xs(3,3)+xs(2,3)*xs(3,2);
        t2(6,5)=xs(1,2)*xs(3,3)+xs(1,3)*xs(3,2);

        t2(1,6)=2.d0*xs(1,3)*xs(1,1);
        t2(2,6)=2.d0*xs(2,3)*xs(2,1);
        t2(3,6)=2.d0*xs(3,3)*xs(3,1);
        t2(4,6)=xs(1,1)*xs(2,3)+xs(1,3)*xs(2,1);
        t2(5,6)=xs(2,1)*xs(3,3)+xs(2,3)*xs(3,1);
        t2(6,6)=xs(1,1)*xs(3,3)+xs(1,3)*xs(3,1);

% C        CALCULATE  T1 MATRIX
%         for j=1:3
%         for i=1:6
% %         tc(i,j)=0.d0
%         for k=1:6
%         tc(i,j)=tc(i,j)-t2(i,k)*c1(k,j);
%         end
%         end
%         end
        tc=-t2*c1;
        
%         for j=1:3
%         for i=1:6
% %         tcj(i,j)=0.d0
%         for k=1:3
%         tcj(i,j)=tcj(i,j)+tc(i,k)*sx(k,j);
%         end
%         end
%         end
        tcj=tc*xs;

%         for n=1:nel
%          for i=1:6
%          at1(i)=0.d0;
%          for k=1:3
%          at1(i)=at1(i)+tcj(i,k)*shl(k,n);
%          end
%          end
%          for i=1:6
%          at2(i)=0.d0;
%          for k=1:6
%            at2(i)=at2(i)+t2(i,k)*shls(k,n);
%          end
%          end
%          for i=1:6
%        shgs(i,n)= at1(i)+at2(i);
%          end
%         end
        shgs = shld*tcj'+shls*t2';
        xs = xs';
                end

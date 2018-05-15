function [shl,shld,shls,bubble] = shltt(ss,nel,nen,der,bf)

% c----------------------------------------------------------------------
% c
%       subroutine shl3dt12(ss,xsj,cartd1,cartd2,xl,ndm,nnp,ideriv)
% c
% c      4 noded, 10 noded tetrahedral element + bubble point
% c
% c      Written by Kaiming Xia, 09/20/2001
% c         Revised by Ramon Calderer, 03/07/2008
% c         Revised by Tim Truster 01/02/2012
% c            Reorganized and verified against previous versions
% c
% c----------------------------------------------------------------------
% c
% c      Purpose: Compute 3-d isoparametric shape
% c               functions and their derivatives w/r x,y,z
% 
% c      Inputs:
% c         ss(3)     - Natural coordinates of point
% c         xl(ndm,*) - Nodal coordinates for element
% c         ndm       - Spatial dimension of mesh
% c             ideriv          - Flag for activation of second derivatives (default=0
% c                     don't compute second derivative
% c      Outputs:
% c         xsj       - Jacobian determinant at point
% c         shl(4,*)  - Shape functions and derivatives at local point
% c         shls(6,*) - Shape functions and derivatives at local point
% c                     cartd(1,i) = dN_i/dx
% c                     cartd(2,i) = dN_i/dy
% c                     cartd(3,i) = dN_i/dz
% c                     cartd(4,i) =  N_i
% c                     cartd2(1,i) = d^2N_i/dx^2
% c                     cartd2(2,i) = d^2N_i/dy^2
% c                     cartd2(3,i) = d^2N_i/dz^2
% c                     cartd2(4,i) = d^2N_i/dxy
% c                     cartd2(5,i) = d^2N_i/dyz
% c                     cartd2(6,i) = d^2N_i/dzx
% c
% c----------------------------------------------------------------------

   shls = zeros(nen,6);
   shld = zeros(nen,3);
   shl = zeros(nen,1);
   bubble = zeros(1,4);
   
%       integer   ndm , i , j , k, inode,nel,nnp,n,ideriv
%       real*8    rxsj,xsj, c1(6,3),tc(6,3),tcj(6,3),at1(6),at2(6)
%       real*8    cartd1(4,nnp),cartd2(6,nnp),shls(6,nnp),t2(6,6)
%       real*8    ss(3),shl(4,nnp),xl(ndm,nnp-1),xs(3,3),ad(3,3),u

%         nel =nnp-1

        u=1.d0-ss(1)-ss(2)-ss(3);
        
        if(nel==4)
% c        shape function for 4 noded tetrahedra 3 dimensional element

        shl(1)=ss(1);
        shl(2)=ss(2);
        shl(3)=u;
        shl(4)=ss(3);
        shld(1,1)=1.d0;
        shld(2,1)=0.d0;
        shld(3,1)=-1.d0;
        shld(4,1)=0.d0;
        shld(1,2)=0.d0;
        shld(2,2)=1.d0;
        shld(3,2)=-1.d0;
        shld(4,2)=0.d0;
        shld(1,3)=0.d0;
        shld(2,3)=0.d0;
        shld(3,3)=-1.d0;
        shld(4,3)=1.d0;

% c     Bubble point
        if bf == 1
%            bubble(1)=256.d0*ss(2)*ss(3)*(u-ss(1));
%            bubble(2)=256.d0*ss(1)*ss(3)*(u-ss(2));
%            bubble(3)=256.d0*ss(1)*ss(2)*(u-ss(3));
%            bubble(4)=256.d0*ss(1)*ss(2)*ss(3)*u;
[b,bd] = bubbleCSTT(ss,eye(3));
bubble = [bd,b];
        end
        
        end
% c
% c for 10 noded 3 dimensional tetrahedra element
% c
        if(nel==10)
        shl(1)=2.d0*ss(1)*(ss(1)-0.5d0);
        shl(2)=2.d0*ss(2)*(ss(2)-0.5d0);
        shl(3)=2.d0*u*(u-0.5d0);
        shl(4)=2.d0*ss(3)*(ss(3)-0.5d0);
        shl(5)=4.d0*ss(1)*ss(2);
        shl(6)=4.d0*ss(2)*u;
        shl(7)=4.d0*ss(1)*u;
        shl(8)=4.d0*ss(1)*ss(3);
        shl(9)=4.d0*ss(2)*ss(3);
        shl(10)=4.d0*ss(3)*u;
        
        shld(1,1)=4.d0*ss(1)-1.d0;
        shld(2,1)=0.d0;
        shld(3,1)=(4.d0*u-1.d0)*(-1.d0);
        shld(4,1)=0.d0;
        shld(5,1)=4.d0*ss(2);
        shld(6,1)=-4.d0*ss(2);
        shld(7,1)=4.d0*(u-ss(1));
        shld(8,1)=4.d0*ss(3);
        shld(9,1)=0.d0;
        shld(10,1)=-4.d0*ss(3);
        
        shld(1,2)=0.d0;
        shld(2,2)=4.0*ss(2)-1.d0;
        shld(3,2)=(4.d0*u-1.d0)*(-1.d0);
        shld(4,2)=0.d0;
        shld(5,2)=4.d0*ss(1);
        shld(6,2)=4.d0*(u-ss(2));
        shld(7,2)=-4.d0*ss(1);
        shld(8,2)=0.d0;
        shld(9,2)=4.d0*ss(3);
        shld(10,2)=-4.d0*ss(3);
        
        shld(1,3)=0.d0;
        shld(2,3)=0.d0;
        shld(3,3)=(4.d0*u-1.d0)*(-1.d0);
        shld(4,3)=4.d0*ss(3)-1.d0;
        shld(5,3)=0.d0;
        shld(6,3)=-4.d0*ss(2);
        shld(7,3)=-4.d0*ss(1);
        shld(8,3)=4.d0*ss(1);
        shld(9,3)=4.d0*ss(2);
        shld(10,3)=4.d0*(u-ss(3));
        
        shls(1,1)=4.d0;
        shls(2,1)=0.d0;
        shls(3,1)=4.d0;
        shls(4,1)=0.d0;
        shls(5,1)=0.d0;
        shls(6,1)=0.d0;
        shls(7,1)=-8.d0;
        shls(8,1)=0.d0;
        shls(9,1)=0.d0;
        shls(10,1)=0.d0;
        
        shls(1,2)=0.d0;
        shls(2,2)=4.d0;
        shls(3,2)=4.d0;
        shls(4,2)=0.d0;
        shls(5,2)=0.d0;
        shls(6,2)=-8.d0;
        shls(7,2)=0.d0;
        shls(8,2)=0.d0;
        shls(9,2)=0.d0;
        shls(10,2)=0.d0;
        
        shls(1,3)=0.d0;
        shls(2,3)=0.d0;
        shls(3,3)=4.d0;
        shls(4,3)=4.d0;
        shls(5,3)=0.d0;
        shls(6,3)=0.d0;
        shls(7,3)=0.d0;
        shls(8,3)=0.d0;
        shls(9,3)=0.d0;
        shls(10,3)=-8.d0;
        
        shls(1,4)=0.d0;
        shls(2,4)=0.d0;
        shls(3,4)=4.d0;
        shls(4,4)=0.d0;
        shls(5,4)=4.d0;
        shls(6,4)=-4.d0;
        shls(7,4)=-4.d0;
        shls(8,4)=0.d0;
        shls(9,4)=0.d0;
        shls(10,4)=0.d0;
        
        shls(1,5)=0.d0;
        shls(2,5)=0.d0;
        shls(3,5)=4.d0;
        shls(4,5)=0.d0;
        shls(5,5)=0.d0;
        shls(6,5)=-4.d0;
        shls(7,5)=0.d0;
        shls(8,5)=0.d0;
        shls(9,5)=4.d0;
        shls(10,5)=-4.d0;
        
        shls(1,6)=0.d0;
        shls(2,6)=0.d0;
        shls(3,6)=4.d0;
        shls(4,6)=0.d0;
        shls(5,6)=0.d0;
        shls(6,6)=0.d0;
        shls(7,6)=-4.d0;
        shls(8,6)=4.d0;
        shls(9,6)=0.d0;
        shls(10,6)=-4.d0;

% c        Bubble point
        if bf == 1
                   bubble(1)=256.d0*ss(2)*ss(3)*(u-ss(1));
                bubble(2)=256.d0*ss(1)*ss(3)*(u-ss(2));
            bubble(3)=256.d0*ss(1)*ss(2)*(u-ss(3));
            bubble(4)=256.d0*ss(1)*ss(2)*ss(3)*u;
%             shls(1,11)=-512.d0;
%             shls(2,11)=-512.d0;
%             shls(3,11)=-512.d0;
%             shls(4,11)=256.d0*ss(3)*(u-ss(1))-256.d0*ss(2)*ss(3);
%             shls(5,11)=256.d0*ss(1)*(u-ss(2))-256.d0*ss(1)*ss(3);
%             shls(6,11)=256.d0*ss(2)*(u-ss(3))-256.d0*ss(1)*ss(2);
        end
        
        end

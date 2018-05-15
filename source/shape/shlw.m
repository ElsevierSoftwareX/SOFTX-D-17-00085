function [shl,shld,shls,bubble] = shlw(ss,nel,nen,der,bf)
% c      Purpose: Compute 3-d wedge 6-node element shape
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
%
% 10/16/2013
% Tim Truster
% Wedge nodes are defined according to the triangular element with node 1
% at the origin, and the bottom face as t=-1 and top face as t=+1

   shls = zeros(6,nen);
   shl = zeros(4,nen);
   bubble = zeros(4,1);

        r=ss(1);
        s=ss(2);
        t=ss(3);
        

% c     Auxiliary variables
zero   = 0.d0;
%         pt1667 = 0.1667d0
pt25   = 0.25d0;
pt5    = 0.5d0;
one    = 1.0d0;
two    = 2.0d0;
%         three  = 3.0d0
four   = 4.0d0;
onept = one + t;
onemt = one - t;
c3 = one - r - s;

% c for 8 noded 3 dimensional brick element
if nel == 6
        shl(1,1)=-onemt/two;
        shl(2,1)=-onemt/two;
        shl(3,1)=-c3/two;
        shl(4,1)=c3*onemt/two; % N1=(1-r-s)*(1-t)/2
        shl(1,2)=onemt/two;
        shl(2,2)=zero;
        shl(3,2)=-r/two;
        shl(4,2)=r*onemt/two; % N2=r*(1-t)/2
        shl(1,3)=zero;
        shl(2,3)=onemt/two;
        shl(3,3)=-s/two;
        shl(4,3)=s*onemt/two; % N3=s*(1-t)/2
        shl(1,4)=-onept/two;
        shl(2,4)=-onept/two;
        shl(3,4)=c3/two;
        shl(4,4)=c3*onept/two; % N4=(1-r-s)*(t+1)/2
        shl(1,5)=onept/two;
        shl(2,5)=zero;
        shl(3,5)=r/two;
        shl(4,5)=r*onept/two; % N5=r*(t+1)/2
        shl(1,6)=zero;
        shl(2,6)=onept/two;
        shl(3,6)=s/two;
        shl(4,6)=s*onept/two; % N6=s*(t+1)/2
        
% C BUBLE POINT
   if bf == 1
       
       error('wedge bubble not defined')
       
   end

% c    calculate second derivatives for shape funtions in local coordinate

        if(der == 1)
        shls(1,1)=0.d0;
        shls(2,1)=0.d0;
        shls(3,1)=0.d0;
        shls(4,1)=0.d0;
        shls(5,1)=pt5;
        shls(6,1)=pt5;
        shls(1,2)=0.d0;
        shls(2,2)=0.d0;
        shls(3,2)=0.d0;
        shls(4,2)=0.d0;
        shls(5,2)=0.d0;
        shls(6,2)=-pt5;
        shls(1,3)=0.d0;
        shls(2,3)=0.d0;
        shls(3,3)=0.d0;
        shls(4,3)=0.d0;
        shls(5,3)=-pt5;
        shls(6,3)=0.d0;
        shls(1,4)=0.d0;
        shls(2,4)=0.d0;
        shls(3,4)=0.d0;
        shls(4,4)=0.d0;
        shls(5,4)=-pt5;
        shls(6,4)=-pt5;
        shls(1,5)=0.d0;
        shls(2,5)=0.d0;
        shls(3,5)=0.d0;
        shls(4,5)=0.d0;
        shls(5,5)=0.d0;
        shls(6,5)=pt5;
        shls(1,6)=0.d0;
        shls(2,6)=0.d0;
        shls(3,6)=0.d0;
        shls(4,6)=0.d0;
        shls(5,6)=pt5;
        shls(6,6)=0.d0;
        end
        

   shls = shls';
   shld = shl(1:3,:)';
   shl = shl(4,:)';
   bubble = bubble';
   
else
    
        u=1.d0-ss(1)-ss(2);
        z = ss(3);
        % bottom
        shl(4,1)=2.d0*ss(1)*(ss(1)-0.5d0) *z*(z-1.d0)/2.d0;
        shl(4,2)=2.d0*ss(2)*(ss(2)-0.5d0) *z*(z-1.d0)/2.d0;
        shl(4,3)=2.d0*u*(u-0.5d0) *z*(z-1.d0)/2.d0;
        shl(4,7)=4.d0*ss(1)*ss(2) *z*(z-1.d0)/2.d0;
        shl(4,8)=4.d0*ss(2)*u *z*(z-1.d0)/2.d0;
        shl(4,9)=4.d0*ss(1)*u *z*(z-1.d0)/2.d0;
        % top
        shl(4,4)=2.d0*ss(1)*(ss(1)-0.5d0) *z*(z+1.d0)/2.d0;
        shl(4,5)=2.d0*ss(2)*(ss(2)-0.5d0) *z*(z+1.d0)/2.d0;
        shl(4,6)=2.d0*u*(u-0.5d0) *z*(z+1.d0)/2.d0;
        shl(4,10)=4.d0*ss(1)*ss(2) *z*(z+1.d0)/2.d0;
        shl(4,11)=4.d0*ss(2)*u *z*(z+1.d0)/2.d0;
        shl(4,12)=4.d0*ss(1)*u *z*(z+1.d0)/2.d0;
        % middle
        shl(4,13)=2.d0*ss(1)*(ss(1)-0.5d0) *(1.d0-z*z);
        shl(4,14)=2.d0*ss(2)*(ss(2)-0.5d0) *(1.d0-z*z);
        shl(4,15)=2.d0*u*(u-0.5d0) *(1.d0-z*z);
        shl(4,16)=4.d0*ss(1)*ss(2) *(1.d0-z*z);
        shl(4,17)=4.d0*ss(2)*u *(1.d0-z*z);
        shl(4,18)=4.d0*ss(1)*u *(1.d0-z*z);
        
        % bottom
        shl(1,1)=(4.d0*ss(1)-1.d0) *z*(z-1.d0)/2.d0;
        shl(1,2)=0.d0 *z*(z-1.d0)/2.d0;
        shl(1,3)=(4.d0*u-1.d0)*(-1.d0) *z*(z-1.d0)/2.d0;
        shl(1,7)=4.d0*ss(2) *z*(z-1.d0)/2.d0;
        shl(1,8)=-4.d0*ss(2) *z*(z-1.d0)/2.d0;
        shl(1,9)=4.d0*(u-ss(1)) *z*(z-1.d0)/2.d0;
        % top
        shl(1,4)=(4.d0*ss(1)-1.d0) *z*(z+1.d0)/2.d0;
        shl(1,5)=0.d0 *z*(z+1.d0)/2.d0;
        shl(1,6)=(4.d0*u-1.d0)*(-1.d0) *z*(z+1.d0)/2.d0;
        shl(1,10)=4.d0*ss(2) *z*(z+1.d0)/2.d0;
        shl(1,11)=-4.d0*ss(2) *z*(z+1.d0)/2.d0;
        shl(1,12)=4.d0*(u-ss(1)) *z*(z+1.d0)/2.d0;
        % middle
        shl(1,13)=(4.d0*ss(1)-1.d0) *(1.d0-z*z);
        shl(1,14)=0.d0 *(1.d0-z*z);
        shl(1,15)=(4.d0*u-1.d0)*(-1.d0) *(1.d0-z*z);
        shl(1,16)=4.d0*ss(2) *(1.d0-z*z);
        shl(1,17)=-4.d0*ss(2) *(1.d0-z*z);
        shl(1,18)=4.d0*(u-ss(1)) *(1.d0-z*z);
        
        % bottom
        shl(2,1)=0.d0 *z*(z-1.d0)/2.d0;
        shl(2,2)=(4.0*ss(2)-1.d0) *z*(z-1.d0)/2.d0;
        shl(2,3)=(4.d0*u-1.d0)*(-1.d0) *z*(z-1.d0)/2.d0;
        shl(2,7)=4.d0*ss(1) *z*(z-1.d0)/2.d0;
        shl(2,8)=4.d0*(u-ss(2)) *z*(z-1.d0)/2.d0;
        shl(2,9)=-4.d0*ss(1) *z*(z-1.d0)/2.d0;
        % top
        shl(2,4)=0.d0 *z*(z+1.d0)/2.d0;
        shl(2,5)=(4.0*ss(2)-1.d0) *z*(z+1.d0)/2.d0;
        shl(2,6)=(4.d0*u-1.d0)*(-1.d0) *z*(z+1.d0)/2.d0;
        shl(2,10)=4.d0*ss(1) *z*(z+1.d0)/2.d0;
        shl(2,11)=4.d0*(u-ss(2)) *z*(z+1.d0)/2.d0;
        shl(2,12)=-4.d0*ss(1) *z*(z+1.d0)/2.d0;
        % middle
        shl(2,13)=0.d0 *(1.d0-z*z);
        shl(2,14)=(4.0*ss(2)-1.d0) *(1.d0-z*z);
        shl(2,15)=(4.d0*u-1.d0)*(-1.d0) *(1.d0-z*z);
        shl(2,16)=4.d0*ss(1) *(1.d0-z*z);
        shl(2,17)=4.d0*(u-ss(2)) *(1.d0-z*z);
        shl(2,18)=-4.d0*ss(1) *(1.d0-z*z);
        
        % bottom
        shl(3,1)=2.d0*ss(1)*(ss(1)-0.5d0) *(2.d0*z-1.d0)/2.d0;
        shl(3,2)=2.d0*ss(2)*(ss(2)-0.5d0) *(2.d0*z-1.d0)/2.d0;
        shl(3,3)=2.d0*u*(u-0.5d0) *(2.d0*z-1.d0)/2.d0;
        shl(3,7)=4.d0*ss(1)*ss(2) *(2.d0*z-1.d0)/2.d0;
        shl(3,8)=4.d0*ss(2)*u *(2.d0*z-1.d0)/2.d0;
        shl(3,9)=4.d0*ss(1)*u *(2.d0*z-1.d0)/2.d0;
        % top
        shl(3,4)=2.d0*ss(1)*(ss(1)-0.5d0) *(2.d0*z+1.d0)/2.d0;
        shl(3,5)=2.d0*ss(2)*(ss(2)-0.5d0) *(2.d0*z+1.d0)/2.d0;
        shl(3,6)=2.d0*u*(u-0.5d0) *(2.d0*z+1.d0)/2.d0;
        shl(3,10)=4.d0*ss(1)*ss(2) *(2.d0*z+1.d0)/2.d0;
        shl(3,11)=4.d0*ss(2)*u *(2.d0*z+1.d0)/2.d0;
        shl(3,12)=4.d0*ss(1)*u *(2.d0*z+1.d0)/2.d0;
        % middle
        shl(3,13)=2.d0*ss(1)*(ss(1)-0.5d0) *(-2.d0*z);
        shl(3,14)=2.d0*ss(2)*(ss(2)-0.5d0) *(-2.d0*z);
        shl(3,15)=2.d0*u*(u-0.5d0) *(-2.d0*z);
        shl(3,16)=4.d0*ss(1)*ss(2) *(-2.d0*z);
        shl(3,17)=4.d0*ss(2)*u *(-2.d0*z);
        shl(3,18)=4.d0*ss(1)*u *(-2.d0*z);
        
% C BUBLE POINT
   if bf == 1
       
       error('wedge bubble not defined')
       
   end

   if der == 1
       
       error('wedge 2nd derivatives not defined')
       
   end
   
   shls = shls';
   shld = shl(1:3,:)';
   shl = shl(4,:)';
   bubble = bubble';
    
end

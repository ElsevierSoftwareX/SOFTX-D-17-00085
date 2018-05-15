function [shl,shld,shls,bubble] = shlb(ss,nel,nen,der,bf)
%         IMPLICIT DOUBLE PRECISION (A-H,O-Z)
% c      3 dimensional 8 noded element + bubble point
% c      By Kaiming Xia 09/20/2001
% c         Second derivatives of shape functions for cartesian coordinates
% c         By Kaiming Xia 11/03/2001
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

   shls = zeros(6,nen);
   shl = zeros(4,nen);
   bubble = zeros(4,1);

        x=ss(1);
        y=ss(2);
        z=ss(3);

    if nel == 8
% c     Auxiliary variables
      onPLz8=(1.d0+z)/8.d0;
	onMIz8=(1.d0-z)/8.d0;

      onPLy8=(1.d0+y)/8.d0;
      onMIy8=(1.d0-y)/8.d0;

% c for 8 noded 3 dimensional brick element
        shl(1,1)=-(1.d0-y)*onMIz8;
        shl(2,1)=-(1.d0-x)*onMIz8;
        shl(3,1)=-(1.d0-x)*onMIy8;
        shl(4,1)=(1.d0-x)*(1.d0-y)*onMIz8;
        shl(1,2)=(1.d0-y)*onMIz8;
        shl(2,2)=-(1.d0+x)*onMIz8;
        shl(3,2)=-(1.d0+x)*onMIy8;
        shl(4,2)=(1.d0+x)*(1.d0-y)*onMIz8;
        shl(1,3)=(1.d0+y)*onMIz8;
        shl(2,3)=(1.d0+x)*onMIz8;
        shl(3,3)=-(1.d0+x)*onPLy8;
        shl(4,3)=(1.d0+x)*(1.d0+y)*onMIz8;
        shl(1,4)=-(1.d0+y)*onMIz8;
        shl(2,4)=(1.d0-x)*onMIz8;
        shl(3,4)=-(1.d0-x)*onPLy8;
        shl(4,4)=(1.d0-x)*(1.d0+y)*onMIz8;
        shl(1,5)=-(1.d0-y)*onPLz8;
        shl(2,5)=-(1.d0-x)*onPLz8;
        shl(3,5)=(1.d0-x)*onMIy8;
        shl(4,5)=(1.d0-x)*(1.d0-y)*onPLz8;
        shl(1,6)=(1.d0-y)*onPLz8;
        shl(2,6)=-(1.d0+x)*onPLz8;
        shl(3,6)=(1.d0+x)*onMIy8;
        shl(4,6)=(1.d0+x)*(1.d0-y)*onPLz8;
        shl(1,7)=(1.d0+y)*onPLz8;
        shl(2,7)=(1.d0+x)*onPLz8;
        shl(3,7)=(1.d0+x)*onPLy8;
        shl(4,7)=(1.d0+x)*(1.d0+y)*onPLz8;
        shl(1,8)=-(1.d0+y)*onPLz8;
        shl(2,8)=(1.d0-x)*onPLz8;
        shl(3,8)=(1.d0-x)*onPLy8;
        shl(4,8)=(1.d0-x)*(1.d0+y)*onPLz8;
        
% C BUBLE POINT
   if bf == 1
       
       if nel == 8
           
        bubble(1)=(-2.d0*x)*(1.d0-y*y)*(1.d0-z*z);
        bubble(2)=(1.d0-x*x)*(-2.d0*y)*(1.d0-z*z);
        bubble(3)=(1.d0-x*x)*(1.d0-y*y)*(-2.d0*z);
        bubble(4)=(1.d0-x*x)*(1.d0-y*y)*(1.d0-z*z);
        
       end
       
   end

% c    calculate second derivatives for shape funtions in local coordinate

        if(der == 1)
        shls(1,1)=0.d0;
        shls(2,1)=0.d0;
        shls(3,1)=0.d0;
        shls(4,1)=onMIz8;
        shls(5,1)=(1.d0-x)/8.d0;
        shls(6,1)=onMIy8;
        shls(1,2)=0.d0;
        shls(2,2)=0.d0;
        shls(3,2)=0.d0;
        shls(4,2)=-onMIz8;
        shls(5,2)=(1.d0+x)/8.d0;
        shls(6,2)=-onMIy8;
        shls(1,3)=0.d0;
        shls(2,3)=0.d0;
        shls(3,3)=0.d0;
        shls(4,3)=onMIz8;
        shls(5,3)=-(1.d0+x)/8.d0;
        shls(6,3)=-onPLy8;
        shls(1,4)=0.d0;
        shls(2,4)=0.d0;
        shls(3,4)=0.d0;
        shls(4,4)=-onMIz8;
        shls(5,4)=-(1.d0-x)/8.d0;
        shls(6,4)=onPLy8;
        shls(1,5)=0.d0;
        shls(2,5)=0.d0;
        shls(3,5)=0.d0;
        shls(4,5)=onPLz8;
        shls(5,5)=-(1.d0-x)/8.d0;
        shls(6,5)=-onMIy8;
        shls(1,6)=0.d0;
        shls(2,6)=0.d0;
        shls(3,6)=0.d0;
        shls(4,6)=-onPLz8;
        shls(5,6)=-(1.d0+x)/8.d0;
        shls(6,6)=onMIy8;
        shls(1,7)=0.d0;
        shls(2,7)=0.d0;
        shls(3,7)=0.d0;
        shls(4,7)=onPLz8;
        shls(5,7)=(1.d0+x)/8.d0;
        shls(6,7)=onPLy8;
        shls(1,8)=0.d0;
        shls(2,8)=0.d0;
        shls(3,8)=0.d0;
        shls(4,8)=-onPLz8;
        shls(5,8)=(1.d0-x)/8.d0;
        shls(6,8)=-onPLy8;
% C for 8 noded 3 dimensional brick element FOR BUBLE POINT
%         shls(1,9)=(-2.d0)*(1.d0-y*y)*(1.d0-z*z)
%         shls(2,9)=(1.d0-x*x)*(-2.d0)*(1.d0-z*z)
%         shls(3,9)=(1.d0-x*x)*(1.d0-y*y)*(-2.d0)
%         shls(4,9)=(-2.d0*x)*(-2.d0*y)*(1.d0-z*z)
%         shls(5,9)=(1.d0-x*x)*(-2.d0*y)*(-2.d0*z)
%         shls(6,9)=(-2.d0*x)*(1.d0-y*y)*(-2.d0*z)
        end
        
    elseif nel == 27
        
        shl(1,1)=(2.d0*x-1.d0)*y*(y-1.d0)*z*(z-1.d0)/8.d0;
         shl(2,1)=x*(x-1.d0)*(2.d0*y-1.d0)*z*(z-1.d0)/8.d0;
        shl(3,1)=x*(x-1.d0)*y*(y-1.d0)*(2.d0*z-1.d0)/8.d0;
        shl(4,1)=x*(x-1.d0)*y*(y-1.d0)*z*(z-1.d0)/8.d0;

        shl(1,2)=(2.d0*x+1.d0)*y*(y-1.d0)*z*(z-1.d0)/8.d0;
        shl(2,2)=x*(x+1.d0)*(2.d0*y-1.d0)*z*(z-1.d0)/8.d0;
        shl(3,2)=x*(x+1.d0)*y*(y-1.d0)*(2.d0*z-1.d0)/8.d0;
        shl(4,2)=x*(x+1.d0)*y*(y-1.d0)*z*(z-1.d0)/8.d0;

        shl(1,3)=(2.d0*x+1.d0)*y*(y+1.d0)*z*(z-1.d0)/8.d0;
        shl(2,3)=x*(x+1.d0)*(2.d0*y+1.d0)*z*(z-1.d0)/8.d0;
        shl(3,3)=x*(x+1.d0)*y*(y+1.d0)*(2.d0*z-1.d0)/8.d0;
        shl(4,3)=x*(x+1.d0)*y*(y+1.d0)*z*(z-1.d0)/8.d0;

        shl(1,4)=(2.d0*x-1.d0)*y*(y+1.d0)*z*(z-1.d0)/8.d0;
        shl(2,4)=x*(x-1.d0)*(2.d0*y+1.d0)*z*(z-1.d0)/8.d0;
        shl(3,4)=x*(x-1.d0)*y*(y+1.d0)*(2.d0*z-1.d0)/8.d0;
        shl(4,4)=x*(x-1.d0)*y*(y+1.d0)*z*(z-1.d0)/8.d0;

        shl(1,5)=(2.d0*x-1.d0)*y*(y-1.d0)*z*(z+1.d0)/8.d0;
        shl(2,5)=x*(x-1.d0)*(2.d0*y-1.d0)*z*(z+1.d0)/8.d0;
        shl(3,5)=x*(x-1.d0)*y*(y-1.d0)*(2.d0*z+1.d0)/8.d0;
        shl(4,5)=x*(x-1.d0)*y*(y-1.d0)*z*(z+1.d0)/8.d0;

        shl(1,6)=(2.d0*x+1.d0)*y*(y-1.d0)*z*(z+1.d0)/8.d0;
        shl(2,6)=x*(x+1.d0)*(2.d0*y-1.d0)*z*(z+1.d0)/8.d0;
        shl(3,6)=x*(x+1.d0)*y*(y-1.d0)*(2.d0*z+1.d0)/8.d0;
        shl(4,6)=x*(x+1.d0)*y*(y-1.d0)*z*(z+1.d0)/8.d0;

        shl(1,7)=(2.d0*x+1.d0)*y*(y+1.d0)*z*(z+1.d0)/8.d0;
        shl(2,7)=x*(x+1.d0)*(2.d0*y+1.d0)*z*(z+1.d0)/8.d0;
        shl(3,7)=x*(x+1.d0)*y*(y+1.d0)*(2.d0*z+1.d0)/8.d0;
        shl(4,7)=x*(x+1.d0)*y*(y+1.d0)*z*(z+1.d0)/8.d0;

        shl(1,8)=(2.d0*x-1.d0)*y*(y+1.d0)*z*(z+1.d0)/8.d0;
        shl(2,8)=x*(x-1.d0)*(2.d0*y+1.d0)*z*(z+1.d0)/8.d0;
        shl(3,8)=x*(x-1.d0)*y*(y+1.d0)*(2.d0*z+1.d0)/8.d0;
        shl(4,8)=x*(x-1.d0)*y*(y+1.d0)*z*(z+1.d0)/8.d0;

        shl(1,17)=(2.d0*x-1.d0)*y*(y-1.d0)*(1.d0-z*z)/4.d0;
        shl(2,17)=x*(x-1.d0)*(2.d0*y-1.d0)*(1.d0-z*z)/4.d0;
        shl(3,17)=x*(x-1.d0)*y*(y-1.d0)*(-2.d0*z)/4.d0;
        shl(4,17)=x*(x-1.d0)*y*(y-1.d0)*(1.d0-z*z)/4.d0;

        shl(1,18)=(2.d0*x+1.d0)*y*(y-1.d0)*(1.d0-z*z)/4.d0;
        shl(2,18)=x*(x+1.d0)*(2.d0*y-1.d0)*(1.d0-z*z)/4.d0;
        shl(3,18)=x*(x+1.d0)*y*(y-1.d0)*(-2.d0*z)/4.d0;
        shl(4,18)=x*(x+1.d0)*y*(y-1.d0)*(1.d0-z*z)/4.d0;

        shl(1,19)=(2.d0*x+1.d0)*y*(y+1.d0)*(1.d0-z*z)/4.d0;
        shl(2,19)=x*(x+1.d0)*(2.d0*y+1.d0)*(1.d0-z*z)/4.d0;
        shl(3,19)=x*(x+1.d0)*y*(y+1.d0)*(-2.d0*z)/4.d0;
        shl(4,19)=x*(x+1.d0)*y*(y+1.d0)*(1.d0-z*z)/4.d0;

        shl(1,20)=(2.d0*x-1.d0)*y*(y+1.d0)*(1.d0-z*z)/4.d0;
        shl(2,20)=x*(x-1.d0)*(2.d0*y+1.d0)*(1.d0-z*z)/4.d0;
        shl(3,20)=x*(x-1.d0)*y*(y+1.d0)*(-2.d0*z)/4.d0;
        shl(4,20)=x*(x-1.d0)*y*(y+1.d0)*(1.d0-z*z)/4.d0;

        shl(1,9)=(-2.d0*x)*y*(y-1.d0)*z*(z-1.d0)/4.d0;
         shl(2,9)=(1.d0-x*x)*(2.d0*y-1.d0)*z*(z-1.d0)/4.d0;
        shl(3,9)=(1.d0-x*x)*y*(y-1.d0)*(2.d0*z-1.d0)/4.d0;
        shl(4,9)=(1.d0-x*x)*y*(y-1.d0)*z*(z-1.d0)/4.d0;

        shl(1,10)=(2.d0*x+1.d0)*(1.d0-y*y)*z*(z-1.d0)/4.d0;
        shl(2,10)=x*(x+1.d0)*(-2.d0*y)*z*(z-1.d0)/4.d0;
        shl(3,10)=x*(x+1.d0)*(1.d0-y*y)*(2.d0*z-1.d0)/4.d0;
        shl(4,10)=x*(x+1.d0)*(1.d0-y*y)*z*(z-1.d0)/4.d0;

        shl(1,11)=(-2.d0*x)*y*(y+1.d0)*z*(z-1.d0)/4.d0;
        shl(2,11)=(1.d0-x*x)*(2.d0*y+1.d0)*z*(z-1.d0)/4.d0;
        shl(3,11)=(1.d0-x*x)*y*(y+1.d0)*(2.d0*z-1.d0)/4.d0;
        shl(4,11)=(1.d0-x*x)*y*(y+1.d0)*z*(z-1.d0)/4.d0;

        shl(1,12)=(2.d0*x-1.d0)*(1.d0-y*y)*z*(z-1.d0)/4.d0;
        shl(2,12)=x*(x-1.d0)*(-2.d0*y)*z*(z-1.d0)/4.d0;
        shl(3,12)=x*(x-1.d0)*(1.d0-y*y)*(2.d0*z-1.d0)/4.d0;
        shl(4,12)=x*(x-1.d0)*(1.d0-y*y)*z*(z-1.d0)/4.d0;

        shl(1,21)=(-2.d0*x)*(1.d0-y*y)*z*(z-1.d0)/2.d0;
        shl(2,21)=(1.d0-x*x)*(-2.d0*y)*z*(z-1.d0)/2.d0;
        shl(3,21)=(1.d0-x*x)*(1.d0-y*y)*(2.d0*z-1.d0)/2.d0;
        shl(4,21)=(1.d0-x*x)*(1.d0-y*y)*z*(z-1.d0)/2.d0;

        shl(1,13)=(-2.d0*x)*y*(y-1.d0)*z*(z+1.d0)/4.d0;
        shl(2,13)=(1.d0-x*x)*(2.d0*y-1.d0)*z*(z+1.d0)/4.d0;
        shl(3,13)=(1.d0-x*x)*y*(y-1.d0)*(2.d0*z+1.d0)/4.d0;
        shl(4,13)=(1.d0-x*x)*y*(y-1.d0)*z*(z+1.d0)/4.d0;

        shl(1,14)=(2.d0*x+1.d0)*(1.d0-y*y)*z*(z+1.d0)/4.d0;
        shl(2,14)=x*(x+1.d0)*(-2.d0*y)*z*(z+1.d0)/4.d0;
        shl(3,14)=x*(x+1.d0)*(1.d0-y*y)*(2.d0*z+1.d0)/4.d0;
        shl(4,14)=x*(x+1.d0)*(1.d0-y*y)*z*(z+1.d0)/4.d0;

        shl(1,15)=(-2.d0*x)*y*(y+1.d0)*z*(z+1.d0)/4.d0;
        shl(2,15)=(1.d0-x*x)*(2.d0*y+1.d0)*z*(z+1.d0)/4.d0;
        shl(3,15)=(1.d0-x*x)*y*(y+1.d0)*(2.d0*z+1.d0)/4.d0;
        shl(4,15)=(1.d0-x*x)*y*(y+1.d0)*z*(z+1.d0)/4.d0;

        shl(1,16)=(2.d0*x-1.d0)*(1.d0-y*y)*z*(z+1.d0)/4.d0;
        shl(2,16)=x*(x-1.d0)*(-2.0*y)*z*(z+1.d0)/4.d0;
        shl(3,16)=x*(x-1.d0)*(1.d0-y*y)*(2.d0*z+1.d0)/4.d0;
        shl(4,16)=x*(x-1.d0)*(1.d0-y*y)*z*(z+1.d0)/4.d0;

        shl(1,22)=(-2.d0*x)*(1.d0-y*y)*z*(z+1.d0)/2.d0;
        shl(2,22)=(1.d0-x*x)*(-2.d0*y)*z*(z+1.d0)/2.d0;
        shl(3,22)=(1.d0-x*x)*(1.d0-y*y)*(2.d0*z+1.d0)/2.d0;
        shl(4,22)=(1.d0-x*x)*(1.d0-y*y)*z*(z+1.d0)/2.d0;

        shl(1,25)=(-2.d0*x)*y*(y-1.d0)*(1.d0-z*z)/2.d0;
        shl(2,25)=(1.d0-x*x)*(2.d0*y-1.d0)*(1.d0-z*z)/2.d0;
        shl(3,25)=(1.d0-x*x)*y*(y-1.d0)*(-2.d0*z)/2.d0;
        shl(4,25)=(1.d0-x*x)*y*(y-1.d0)*(1.d0-z*z)/2.d0;

        shl(1,24)=(2.d0*x+1.d0)*(1.d0-y*y)*(1.d0-z*z)/2.d0;
        shl(2,24)=x*(x+1.d0)*(-2.d0*y)*(1.d0-z*z)/2.d0;
        shl(3,24)=x*(x+1.d0)*(1.d0-y*y)*(-2.d0*z)/2.d0;
        shl(4,24)=x*(x+1.d0)*(1.d0-y*y)*(1.d0-z*z)/2.d0;

        shl(1,26)=(-2.d0*x)*y*(y+1.d0)*(1.d0-z*z)/2.d0;
        shl(2,26)=(1.d0-x*x)*(2.d0*y+1.d0)*(1.d0-z*z)/2.d0;
        shl(3,26)=(1.d0-x*x)*y*(y+1.d0)*(-2.d0*z)/2.d0;
        shl(4,26)=(1.d0-x*x)*y*(y+1.d0)*(1.d0-z*z)/2.d0;

        shl(1,23)=(2.d0*x-1.d0)*(1.d0-y*y)*(1.d0-z*z)/2.d0;
        shl(2,23)=x*(x-1.d0)*(-2.d0*y)*(1.d0-z*z)/2.d0;
        shl(3,23)=x*(x-1.d0)*(1.d0-y*y)*(-2.d0*z)/2.d0;
        shl(4,23)=x*(x-1.d0)*(1.d0-y*y)*(1.d0-z*z)/2.d0;

        shl(1,27)=(-2.d0*x)*(1.d0-y*y)*(1.d0-z*z);
        shl(2,27)=(1.d0-x*x)*(-2.d0*y)*(1.d0-z*z);
        shl(3,27)=(1.d0-x*x)*(1.d0-y*y)*(-2.d0*z);
        shl(4,27)=(1.d0-x*x)*(1.d0-y*y)*(1.d0-z*z);

% c       Bubble node
        if bf == 1
            
        bubble(1)=(-4.d0*x*x*x)*(1.d0-y*y*y*y)*(1.d0-z*z*z*z);
        bubble(2)=(1.d0-x*x*x*x)*(-4.d0*y*y*y)*(1.d0-z*z*z*z);
        bubble(3)=(1.d0-x*x*x*x)*(1.d0-y*y*y*y)*(-4.d0*z*z*z);
        bubble(4)=(1.d0-x*x*x*x)*(1.d0-y*y*y*y)*(1.d0-z*z*z*z);
        
        end

% c     calculate second derivatives for shape funtions in local coordinate

      if der == 1

% c       For 27 noded 3 dimensional brick element

        shls(1,1)=2.d0*y*(y-1.d0)*z*(z-1.d0)/8.d0;
        shls(2,1)=x*(x-1.d0)*2.d0*z*(z-1.d0)/8.d0;
        shls(3,1)=x*(x-1.d0)*y*(y-1.d0)*2.d0/8.d0;
        shls(4,1)=(2.d0*x-1.d0)*(2.d0*y-1.d0)*z*(z-1.d0)/8.d0;
        shls(5,1)=x*(x-1.d0)*(2.d0*y-1.d0)*(2.d0*z-1.d0)/8.d0;
        shls(6,1)=(2.d0*x-1.d0)*y*(y-1.d0)*(2.d0*z-1.d0)/8.d0;

        shls(1,2)=2.d0*y*(y-1.d0)*z*(z-1.d0)/8.d0;
        shls(2,2)=x*(x+1.d0)*2.d0*z*(z-1.d0)/8.d0;
        shls(3,2)=x*(x+1.d0)*y*(y-1.d0)*2.d0/8.d0;
        shls(4,2)=(2.d0*x+1.d0)*(2.d0*y-1.d0)*z*(z-1.d0)/8.d0;
        shls(5,2)=x*(x+1.d0)*(2.d0*y-1.d0)*(2.d0*z-1.d0)/8.d0;
        shls(6,2)=(2.d0*x+1.d0)*y*(y-1.d0)*(2.d0*z-1.d0)/8.d0;

        shls(1,3)=2.d0*y*(y+1.d0)*z*(z-1.d0)/8.d0;
        shls(2,3)=x*(x+1.d0)*2.d0*z*(z-1.d0)/8.d0;
        shls(3,3)=x*(x+1.d0)*y*(y+1.d0)*2.d0/8.d0;
        shls(4,3)=(2.d0*x+1.d0)*(2.d0*y+1.d0)*z*(z-1.d0)/8.d0;
        shls(5,3)=x*(x+1.d0)*(2.d0*y+1.d0)*(2.d0*z-1.d0)/8.d0;
        shls(6,3)=(2.d0*x+1.d0)*y*(y+1.d0)*(2.d0*z-1.d0)/8.d0;

        shls(1,4)=2.d0*y*(y+1.d0)*z*(z-1.d0)/8.d0;
        shls(2,4)=x*(x-1.d0)*2.d0*z*(z-1.d0)/8.d0;
        shls(3,4)=x*(x-1.d0)*y*(y+1.d0)*2.d0/8.d0;
        shls(4,4)=(2.d0*x-1.d0)*(2.d0*y+1.d0)*z*(z-1.d0)/8.d0;
        shls(5,4)=x*(x-1.d0)*(2.d0*y+1.d0)*(2.d0*z-1.d0)/8.d0;
        shls(6,4)=(2.d0*x-1.d0)*y*(y+1.d0)*(2.d0*z-1.d0)/8.d0;

        shls(1,5)=2.d0*y*(y-1.d0)*z*(z+1.d0)/8.d0;
        shls(2,5)=x*(x-1.d0)*2.d0*z*(z+1.d0)/8.d0;
        shls(3,5)=x*(x-1.d0)*y*(y-1.d0)*2.d0/8.d0;
        shls(4,5)=(2.d0*x-1.d0)*(2.d0*y-1.d0)*z*(z+1.d0)/8.d0;
        shls(5,5)=x*(x-1.d0)*(2.d0*y-1.d0)*(2.d0*z+1.d0)/8.d0;
        shls(6,5)=(2.d0*x-1.d0)*y*(y-1.d0)*(2.d0*z+1.d0)/8.d0;

        shls(1,6)=2.d0*y*(y-1.d0)*z*(z+1.d0)/8.d0;
        shls(2,6)=x*(x+1.d0)*2.d0*z*(z+1.d0)/8.d0;
        shls(3,6)=x*(x+1.d0)*y*(y-1.d0)*2.d0/8.d0;
        shls(4,6)=(2.d0*x+1.d0)*(2.d0*y-1.d0)*z*(z+1.d0)/8.d0;
        shls(5,6)=x*(x+1.d0)*(2.d0*y-1.d0)*(2.d0*z+1.d0)/8.d0;
        shls(6,6)=(2.d0*x+1.d0)*y*(y-1.d0)*(2.d0*z+1.d0)/8.d0;

        shls(1,7)=2.d0*y*(y+1.d0)*z*(z+1.d0)/8.d0;
        shls(2,7)=x*(x+1.d0)*2.d0*z*(z+1.d0)/8.d0;
        shls(3,7)=x*(x+1.d0)*y*(y+1.d0)*2.d0/8.d0;
        shls(4,7)=(2.d0*x+1.d0)*(2.d0*y+1.d0)*z*(z+1.d0)/8.d0;
        shls(5,7)=x*(x+1.d0)*(2.d0*y+1.d0)*(2.d0*z+1.d0)/8.d0;
        shls(6,7)=(2.d0*x+1.d0)*y*(y+1.d0)*(2.d0*z+1.d0)/8.d0;

        shls(1,8)=2.d0*y*(y+1.d0)*z*(z+1.d0)/8.d0;
        shls(2,8)=x*(x-1.d0)*2.d0*z*(z+1.d0)/8.d0;
        shls(3,8)=x*(x-1.d0)*y*(y+1.d0)*2.d0/8.d0;
        shls(4,8)=(2.d0*x-1.d0)*(2.d0*y+1.d0)*z*(z+1.d0)/8.d0;
        shls(5,8)=x*(x-1.d0)*(2.d0*y+1.d0)*(2.d0*z+1.d0)/8.d0;
        shls(6,8)=(2.d0*x-1.d0)*y*(y+1.d0)*(2.d0*z+1.d0)/8.d0;

        shls(1,17)=2.d0*y*(y-1.d0)*(1.d0-z*z)/4.d0;
        shls(2,17)=x*(x-1.d0)*2.d0*(1.d0-z*z)/4.d0;
        shls(3,17)=x*(x-1.d0)*y*(y-1.d0)*(-2.d0)/4.d0;
        shls(4,17)=(2.d0*x-1.d0)*(2.d0*y-1.d0)*(1.d0-z*z)/4.d0;
        shls(5,17)=x*(x-1.d0)*(2.d0*y-1.d0)*(-2.d0*z)/4.d0;
        shls(6,17)=(2.d0*x-1.d0)*y*(y-1.d0)*(-2.d0*z)/4.d0;

        shls(1,18)=2.d0*y*(y-1.d0)*(1.d0-z*z)/4.d0;
        shls(2,18)=x*(x+1.d0)*2.d0*(1.d0-z*z)/4.d0;
        shls(3,18)=x*(x+1.d0)*y*(y-1.d0)*(-2.d0)/4.d0;
        shls(4,18)=(2.d0*x+1.d0)*(2.d0*y-1.d0)*(1.d0-z*z)/4.d0;
        shls(5,18)=x*(x+1.d0)*(2.d0*y-1.d0)*(-2.d0*z)/4.d0;
        shls(6,18)=(2.d0*x+1.d0)*y*(y-1.d0)*(-2.d0*z)/4.d0;

        shls(1,19)=2.d0*y*(y+1.d0)*(1.d0-z*z)/4.d0;
        shls(2,19)=x*(x+1.d0)*2.d0*(1.d0-z*z)/4.d0;
        shls(3,19)=x*(x+1.d0)*y*(y+1.d0)*(-2.d0)/4.d0;
        shls(4,19)=(2.d0*x+1.d0)*(2.d0*y+1.d0)*(1.d0-z*z)/4.d0;
        shls(5,19)=x*(x+1.d0)*(2.d0*y+1.d0)*(-2.d0*z)/4.d0;
        shls(6,19)=(2.d0*x+1.d0)*y*(y+1.d0)*(-2.d0*z)/4.d0;

        shls(1,20)=2.d0*y*(y+1.d0)*(1.d0-z*z)/4.d0;
        shls(2,20)=x*(x-1.d0)*2.d0*(1.d0-z*z)/4.d0;
        shls(3,20)=x*(x-1.d0)*y*(y+1.d0)*(-2.d0)/4.d0;
        shls(4,20)=(2.d0*x-1.d0)*(2.d0*y+1.d0)*(1.d0-z*z)/4.d0;
        shls(5,20)=x*(x-1.d0)*(2.d0*y+1.d0)*(-2.d0*z)/4.d0;
        shls(6,20)=(2.d0*x-1.d0)*y*(y+1.d0)*(-2.d0*z)/4.d0;

        shls(1,9)=(-2.d0)*y*(y-1.d0)*z*(z-1.d0)/4.d0;
        shls(2,9)=(1.d0-x*x)*2.d0*z*(z-1.d0)/4.d0;
        shls(3,9)=(1.d0-x*x)*y*(y-1.d0)*2.d0/4.d0;
        shls(4,9)=(-2.d0*x)*(2.d0*y-1.d0)*z*(z-1.d0)/4.d0;
        shls(5,9)=(1.d0-x*x)*(2.d0*y-1.d0)*(2.d0*z-1.d0)/4.d0;
        shls(6,9)=(-2.d0*x)*y*(y-1.d0)*(2.d0*z-1.d0)/4.d0;

        shls(1,10)=2.d0*(1.d0-y*y)*z*(z-1.d0)/4.d0;
        shls(2,10)=x*(x+1.d0)*(-2.d0)*z*(z-1.d0)/4.d0;
        shls(3,10)=x*(x+1.d0)*(1.d0-y*y)*2.d0/4.d0;
        shls(4,10)=(2.d0*x+1.d0)*(-2.d0*y)*z*(z-1.d0)/4.d0;
        shls(5,10)=x*(x+1.d0)*(-2.d0*y)*(2.d0*z-1.d0)/4.d0;
        shls(6,10)=(2.D0*x+1.d0)*(1.d0-y*y)*(2.d0*z-1.d0)/4.d0;

        shls(1,11)=(-2.d0)*y*(y+1.d0)*z*(z-1.d0)/4.d0;
        shls(2,11)=(1.d0-x*x)*2.d0*z*(z-1.d0)/4.d0;
        shls(3,11)=(1.d0-x*x)*y*(y+1.d0)*2.d0/4.d0;
        shls(4,11)=(-2.d0*x)*(2.D0*y+1.d0)*z*(z-1.d0)/4.d0;
        shls(5,11)=(1.d0-x*x)*(2.d0*y+1.d0)*(2.D0*z-1.d0)/4.d0;
        shls(6,11)=(-2.D0*x)*y*(y+1.d0)*(2.d0*z-1.d0)/4.d0;

        shls(1,12)=2.d0*(1.d0-y*y)*z*(z-1.d0)/4.d0;
        shls(2,12)=x*(x-1.d0)*(-2.d0)*z*(z-1.d0)/4.d0;
        shls(3,12)=x*(x-1.d0)*(1.d0-y*y)*2.d0/4.d0;
        shls(4,12)=(2.d0*x-1.d0)*(-2.D0*y)*z*(z-1.d0)/4.d0;
        shls(5,12)=x*(x-1.d0)*(-2.d0*y)*(2.D0*z-1.d0)/4.d0;
        shls(6,12)=(2.D0*x-1.d0)*(1.d0-y*y)*(2.d0*z-1.d0)/4.d0;

        shls(1,21)=(-2.d0)*(1.d0-y*y)*z*(z-1.d0)/2.d0;
        shls(2,21)=(1.d0-x*x)*(-2.d0)*z*(z-1.d0)/2.d0;
        shls(3,21)=(1.d0-x*x)*(1.d0-y*y)*2.d0/2.d0;
        shls(4,21)=(-2.d0*x)*(-2.D0*y)*z*(z-1.d0)/2.d0;
        shls(5,21)=(1.d0-x*x)*(-2.d0*y)*(2.D0*z-1.d0)/2.d0;
        shls(6,21)=(-2.D0*x)*(1.d0-y*y)*(2.d0*z-1.d0)/2.d0;

        shls(1,13)=(-2.d0)*y*(y-1.d0)*z*(z+1.d0)/4.d0;
        shls(2,13)=(1.d0-x*x)*2.d0*z*(z+1.d0)/4.d0;
        shls(3,13)=(1.d0-x*x)*y*(y-1.d0)*2.d0/4.d0;
        shls(4,13)=(-2.d0*x)*(2.D0*y-1.d0)*z*(z+1.d0)/4.d0;
        shls(5,13)=(1.d0-x*x)*(2.d0*y-1.d0)*(2.D0*z+1.d0)/4.d0;
        shls(6,13)=(-2.D0*x)*y*(y-1.d0)*(2.d0*z+1.d0)/4.d0;

        shls(1,14)=2.d0*(1.d0-y*y)*z*(z+1.d0)/4.d0;
        shls(2,14)=x*(x+1.d0)*(-2.d0)*z*(z+1.d0)/4.d0;
        shls(3,14)=x*(x+1.d0)*(1.d0-y*y)*2.d0/4.d0;
        shls(4,14)=(2.d0*x+1.d0)*(-2.D0*y)*z*(z+1.d0)/4.d0;
        shls(5,14)=x*(x+1.d0)*(-2.d0*y)*(2.D0*z+1.d0)/4.d0;
        shls(6,14)=(2.D0*x+1.d0)*(1.d0-y*y)*(2.d0*z+1.d0)/4.d0;

        shls(1,15)=(-2.d0)*y*(y+1.d0)*z*(z+1.d0)/4.d0;
        shls(2,15)=(1.d0-x*x)*2.d0*z*(z+1.d0)/4.d0;
        shls(3,15)=(1.d0-x*x)*y*(y+1.d0)*2.d0/4.d0;
        shls(4,15)=(-2.d0*x)*(2.D0*y+1.d0)*z*(z+1.d0)/4.d0;
        shls(5,15)=(1.d0-x*x)*(2.d0*y+1.d0)*(2.D0*z+1.d0)/4.d0;
        shls(6,15)=(-2.D0*x)*y*(y+1.d0)*(2.d0*z+1.d0)/4.d0;

        shls(1,16)=2.d0*(1.d0-y*y)*z*(z+1.d0)/4.d0;
        shls(2,16)=x*(x-1.d0)*(-2.0)*z*(z+1.d0)/4.d0;
        shls(3,16)=x*(x-1.d0)*(1.d0-y*y)*2.d0/4.d0;
        shls(4,16)=(2.d0*x-1.d0)*(-2.d0*y)*z*(z+1.d0)/4.d0;
        shls(5,16)=x*(x-1.d0)*(-2.0*y)*(2.d0*z+1.d0)/4.d0;
        shls(6,16)=(2.d0*x-1.d0)*(1.d0-y*y)*(2.d0*z+1.d0)/4.d0;

        shls(1,22)=(-2.d0)*(1.d0-y*y)*z*(z+1.d0)/2.d0;
        shls(2,22)=(1.d0-x*x)*(-2.d0)*z*(z+1.d0)/2.d0;
        shls(3,22)=(1.d0-x*x)*(1.d0-y*y)*2.d0/2.d0;
        shls(4,22)=(-2.d0*x)*(-2.d0*y)*z*(z+1.d0)/2.d0;
        shls(5,22)=(1.d0-x*x)*(-2.d0*y)*(2.d0*z+1.d0)/2.d0;
        shls(6,22)=(-2.d0*x)*(1.d0-y*y)*(2.d0*z+1.d0)/2.d0;

        shls(1,25)=(-2.d0)*y*(y-1.d0)*(1.d0-z*z)/2.d0;
         shls(2,25)=(1.d0-x*x)*2.d0*(1.d0-z*z)/2.d0;
        shls(3,25)=(1.d0-x*x)*y*(y-1.d0)*(-2.d0)/2.d0;
        shls(4,25)=(-2.d0*x)*(2.d0*y-1.d0)*(1.d0-z*z)/2.d0;
         shls(5,25)=(1.d0-x*x)*(2.d0*y-1.d0)*(-2.d0*z)/2.d0;
        shls(6,25)=(-2.d0*x)*y*(y-1.d0)*(-2.d0*z)/2.d0;

        shls(1,24)=2.d0*(1.d0-y*y)*(1.d0-z*z)/2.d0;
        shls(2,24)=x*(x+1.d0)*(-2.d0)*(1.d0-z*z)/2.d0;
        shls(3,24)=x*(x+1.d0)*(1.d0-y*y)*(-2.d0)/2.d0;
        shls(4,24)=(2.d0*x+1.d0)*(-2.d0*y)*(1.d0-z*z)/2.d0;
        shls(5,24)=x*(x+1.d0)*(-2.d0*y)*(-2.d0*z)/2.d0;
        shls(6,24)=(2.d0*x+1.d0)*(1.d0-y*y)*(-2.d0*z)/2.d0;

        shls(1,26)=(-2.d0)*y*(y+1.d0)*(1.d0-z*z)/2.d0;
        shls(2,26)=(1.d0-x*x)*2.d0*(1.d0-z*z)/2.d0;
        shls(3,26)=(1.d0-x*x)*y*(y+1.d0)*(-2.d0)/2.d0;
        shls(4,26)=(-2.d0*x)*(2.d0*y+1.d0)*(1.d0-z*z)/2.d0;
        shls(5,26)=(1.d0-x*x)*(2.d0*y+1.d0)*(-2.d0*z)/2.d0;
        shls(6,26)=(-2.d0*x)*y*(y+1.d0)*(-2.d0*z)/2.d0;

        shls(1,23)=2.d0*(1.d0-y*y)*(1.d0-z*z)/2.d0;
        shls(2,23)=x*(x-1.d0)*(-2.d0)*(1.d0-z*z)/2.d0;
        shls(3,23)=x*(x-1.d0)*(1.d0-y*y)*(-2.d0)/2.d0;
        shls(4,23)=(2.d0*x-1.d0)*(-2.d0*y)*(1.d0-z*z)/2.d0;
        shls(5,23)=x*(x-1.d0)*(-2.d0*y)*(-2.d0*z)/2.d0;
        shls(6,23)=(2.d0*x-1.d0)*(1.d0-y*y)*(-2.d0*z)/2.d0;

        shls(1,27)=(-2.d0)*(1.d0-y*y)*(1.d0-z*z);
        shls(2,27)=(1.d0-x*x)*(-2.d0)*(1.d0-z*z);
        shls(3,27)=(1.d0-x*x)*(1.d0-y*y)*(-2.d0);
        shls(4,27)=(-2.d0*x)*(-2.d0*y)*(1.d0-z*z);
        shls(5,27)=(1.d0-x*x)*(-2.d0*y)*(-2.d0*z);
        shls(6,27)=(-2.d0*x)*(1.d0-y*y)*(-2.d0*z);

% % c       Bubble node
%         shls(1,28)=(-12.d0*x*x)*(1.d0-y*y*y*y)*(1.d0-z*z*z*z)
%         shls(2,28)=(1.d0-x*x*x*x)*(-12.d0*y*y)*(1.d0-z*z*z*z)
%         shls(3,28)=(1.d0-x*x*x*x)*(1.d0-y*y*y*y)*(-12.d0*z*z)
%         shls(4,28)=(-4.d0*x*x*x)*(-4.d0*y*y*y)*(1.d0-z*z*z*z)
%         shls(5,28)=(1.d0-x*x*x*x)*(-4.d0*y*y*y)*(-4.d0*z*z*z)
%         shls(6,28)=(-4.d0*x*x*x)*(1.d0-y*y*y*y)*(-4.d0*z*z*z)

      end
        
    end

   shls = shls';
   shld = shl(1:3,:)';
   shl = shl(4,:)';
   bubble = bubble';

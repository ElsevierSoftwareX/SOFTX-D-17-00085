function [shgd,shgs,det,bubble,sx] = shgt(xl,nel,shld,shls,nen,bf,der,bubble)                
% c                                                                          
% c.... Program to calculate jacobian determinant, global shape fnctns, global
% c     shape fnctn 1st derivatives, and global shape fnctn 2nd derivatives
% c     at a given integration point, for a 4 or 9 node QUADRILATERAL element                
% c                                                                          
% c         xl(j,i)  = global coordinates from calling program
% c         nel      = no. of nodes on the current element from calling program                                  
% c         shl(1,i) = 1st "xi" derivative of shape fnctn from calling program           
% c         shl(2,i) = 1st "eta" derivative of shape fnctn from calling program          
% c         shl(3,i) = shape function in ref domain from calling program
% c         shls(1,i) = 2nd "xi" derivative of shape fnctn from calling program           
% c         shls(2,i) = 2nd "eta" derivative of shape fnctn from calling program          
% c         shls(3,i) = 2nd "xi-eta" deriv of shape fnctn from calling program
% c         bubble(1) = 1st "xi" derivative of bubble fnctn from calling program             
% c         bubble(2) = 1st "eta" derivative of bubble fnctn from calling program            
% c         bubble(3) = ref domain bubble fnctn from calling program        
% c         neg  =
% c         nen  =
% c         der  = flag for 2nd derivatives
% c         bf   = flag for bubble function                               
% c         det      = jacobian determinant at current integr pt (returned)                                
% c         shg(1,i) = global x-derivative of shape function (returned)                       
% c         shg(2,i) = global y-derivative of shape function  (returned)                     
% c         shg(3,i) = global shape fnctn at integr pt (=shl(3,i)) (returned)
% c         shgs(1,k) = global 2nd x-x-derivative of shape function (returned)             
% c         shgs(2,k) = global 2nd y-y-derivative of shape function (returned)            
% c         shgs(3,k) = global 2nd x-y-deriv of shape fnctn (returned)
% c         bubble(1) = global x-derivative of bubble function (returned)             
% c         bubble(2) = global y-derivative of bubble function (returned)            
% c         bubble(3) = global bubble function (returned)
% c         xs = jacobian matrix (returned)                                        
% c         xs(i,j)  = inverse jacobian matrix                                      
% c                 i = local node number or global coordinate number        
% c                 j = global coordinate number                             
% c                                                                          
% c.... Written by A Masud. (Spring 1987) Modified by S Cain (Fall 1996)                                                                         
% c
% c
% c      implicit real*8 (a-h,o-z)
%       implicit none
% c
% c.... remove above card for single precision operation
% c
%       integer nel,i,j,k,iin,iout,irsin,irsout,nen,neg,m
%       logical der,bf
%       Real*8 zero,pt1667,pt25,pt5,one,two,three,four,five,six
%       Real*8 det,temp
%       Real*8 xl(2,10),shl(3,nel),shls(3,nel),shg(3,nel),bubble(3)
%       Real*8 shgs(3,nel),xs(2,2),sx(2,2)    
%       Real*8 t1(2,3),t2(3,3),c1(2,3)
%       shl = zeros(3,nel);
%       shls = zeros(3,nel);
%       shgd = zeros(nen,2);
%       bubble(3)
      shgs = zeros(nen,3);
      xs = zeros(2,2);
%       sx = zeros(2,2);    
%       t1 = zeros(2,3);
      t2 = zeros(3,3);
%       c1 = zeros(2,3);
      
% c
% c      for feap (Arif Masud)
%        integer         ior,iow
%        common /iofile/ ior,iow
%        common /iounit/ iin,iout,irsin,irsout
% c
% c.... define some constants
%       zero   = 0.d0;
%         pt1667 = 0.1667d0;
%         pt25   = 0.25d0;
%         pt5    = 0.5d0;
%         one    = 1.0d0;
        two    = 2.0d0;
%         three  = 3.0d0;
%         four   = 4.0d0;
%         five   = 5.0d0;
%         six    = 6.0d0;
% c
% c     Construct Jacobian of Quadrilateral Element.
% c     --------------------------------------------
%         for  i=1:2
%           for  j=1:2
% %             sx(i,j)= zero;
%             for  k=1:nel
%               sx(i,j)= sx(i,j)+xl(i,k)*shl(j,k);
%             end
%           end
%         end
        sx = xl(:,1:nel)*shld;
% c                    
        det = sx(1,1)*sx(2,2)-sx(1,2)*sx(2,1);
%         if (det.le.zero) then
%           write(iout,1000) nen,neg
%           stop
%         endif
% c
% c     Construct Inverse of Jacobian of Quadrilateral Element.
% c     -------------------------------------------------------
        xs(1,1) = sx(2,2)/det;
        xs(2,2) = sx(1,1)/det;
        xs(1,2) =-sx(1,2)/det;
        xs(2,1) =-sx(2,1)/det;      
% c
% c     Calculate Global Shape Functions of Quadrilateral Element.
% c     ----------------------------------------------------------
%         for  i=1:nel
%           shgd(1,i) = shld(1,i)*xs(1,1) + shl(2,i)*xs(2,1);
%           shgd(2,i) = shld(1,i)*xs(1,2) + shl(2,i)*xs(2,2);
%         end
        shgd = shld*xs;
% c
        
        if bf == 1
%           temp = bubble(1);
%           bubble(1) = temp*xs(1,1) + bubble(2)*xs(2,1);
%           bubble(2) = temp*xs(1,2) + bubble(2)*xs(2,2);
% %           bubble(3) = bubble(3)
          bubble(1:2) = bubble(1:2)*xs;
        end
% c     
% c     Calculate Global Shape Function Second Derivatives of Quadrilat Elmnt
% c     ---------------------------------------------------------------------
% c      
% c     {d2global} = {dlocal} [t1] + {d2local} [t2]
% c     [t1] = -[xs] [c1] [t2]
% c

      if der == 1

% c      forming t2 matrix
% c      -----------------
% c
      for i = 1:2
        t2(i,3) = xs(i,1)*xs(i,2);
        t2(3,i) = two*xs(1,i)*xs(2,i);
        for j = 1:2
          t2(i,j) = xs(i,j)*xs(i,j);
        end
      end
      t2(3,3) = xs(1,1)*xs(2,2) + xs(2,1)*xs(1,2);
% c
% c       forming c1 matrix
% c       -----------------
%       for  i = 1:3
%       for  j = 1:2
% %         c1(j,i) = zero
%       for  k = 1:nel
%         c1(j,i) = c1(j,i)+xl(j,k)*shls(i,k);
%       end
%       end
%       end
      c1 = xl(:,1:nel)*shls;
% c
% c       forming t1 matrix
% c       -----------------
%       for i=1:2
%       for j=1:3
% %         t1(i,j)= zero
%       for k=1:3
%         t1(i,j)=t1(i,j)-(xs(i,1)*c1(1,k)+xs(i,2)*c1(2,k))*t2(k,j);
%       end
%       end
%       end
      t1 = -xs*c1*t2;
% c
% c     calculation of global second derivatives of quadrilateral element
% c     -----------------------------------------------------------------
%       for j=1:nel
%       for i=1:3
% %         shgs(i,j)= zero
%         for k=1:2
%           shgs(i,j)=shgs(i,j) + shl(k,j)*t1(k,i);
%         end
%         for k=1:3
%           shgs(i,j)=shgs(i,j) + shls(k,j)*t2(k,i);
%         end
% % c
%       end
%       end
      shgs = shld*t1 + shls*t2;
% c
      end %if
% c     End Global Second Derivatives of Quadrilateral Element
%       return
% c
%  1000 format('1','non-positive determinant in element number  ',i5,
%      &          ' in element material group  ',i5)
      end
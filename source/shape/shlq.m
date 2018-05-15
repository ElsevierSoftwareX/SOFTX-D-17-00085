function [shl,shld,shls,bubble] = shlq(r,s,nel,nen,der,bf)
% c
% c.... Program to calculate integration-rule weight, shape functions, and 
% c     shape fnctn 1st and 2nd derivatives in the reference coordinate system,
% c     at a given integration pt "l", for a 4 or 9 node QUADRILATERAL element         
% c                                                                            
% c         l    = current integration point counter from calling program
% c         lint = total no. of integration pts from calling program (1,4,9,16,100)
% c         nel  = total no. of nodes in element (4 or 9), from calling program
% c         ib   = flag for interior (0) or boundary (1-4) integration
% c         der  = flag for 2nd derivatives
% c         bf   = flag for bubble function  
% c         w    = integration-rule weight @ the current integration pt "l" (returned)                               
% c         shl(1,k) = 1st "xi" derivative of shape function (returned)             
% c         shl(2,k) = 1st "eta" derivative of shape function (returned)            
% c         shl(3,k) = ref domain shape function (returned)                                 
% c         shls(1,k) = 2nd "xi" derivative of shape function (returned)             
% c         shls(2,k) = 2nd "eta" derivative of shape function (returned)            
% c         shls(3,k) = 2nd "xi-eta" (cross) deriv of shape function (returned)
% c         bubble(1) = 1st "xi" derivative of bubble function (returned)             
% c         bubble(2) = 1st "eta" derivative of bubble function (returned)            
% c         bubble(3) = ref domain bubble function (returned)                              
% c                                                                            
% c.... Written by A Masud (Spring 1987) Modified by S Cain (Fall 1996)                                  
% c.... Modified by A. Masud and R.A. Khurram (Fall 2001)
% c.... Modified by J. Patrick (Summer 2008)
% c.... Modified by T. Truster (Fall 2009)
% c
% c      implicit real*8 (a-h,o-z)
% 
%       implicit none
% c
% c.... deactivate above card for single precision operation
% c
%       integer nel
%       logical der,bf
shl = zeros(nen,1);
shld = zeros(nen,2);
shls = zeros(nen,3);
bubble = zeros(1,3);
%       integer i,k
%       real*8 zero,pt1667,pt25,pt5,one,two,three,four,five,six 
%       real*8 r,s,onepr,onemr,oneps,onems,onemrsq,onemssq
% 
% c.... define some constants (for feap)
zero   = 0.d0;
%         pt1667 = 0.1667d0
pt25   = 0.25d0;
pt5    = 0.5d0;
one    = 1.0d0;
two    = 2.0d0;
%         three  = 3.0d0
four   = 4.0d0;
%         five   = 5.0d0
%         six    = 6.0d0
      
% c
% c     Forming the Local First Derivatives of Quadrilateral Element.
% c     -------------------------------------------------------------
% c
onepr = one + r;
onemr = one - r;
oneps = one + s;
onems = one - s;
% c
shld(1,1) =-onems*pt25;
shld(1,2) =-onemr*pt25;
shl(1,1) = onemr*onems*pt25;
% c
shld(2,1) = onems*pt25;
shld(2,2) =-onepr*pt25;
shl(2,1) = onepr*onems*pt25;
% c
shld(3,1) = oneps*pt25;
shld(3,2) = onepr*pt25;
shl(3,1) = onepr*oneps*pt25;
% c
shld(4,1) =-oneps*pt25;
shld(4,2) = onemr*pt25;
shl(4,1) = onemr*oneps*pt25;
% c
if nel == 9
  onemrsq = one - r*r;
  onemssq = one - s*s;
% c
  shld(5,1) =-r*onems;
  shld(5,2) =-onemrsq*pt5;
  shl(5,1) = onemrsq*onems*pt5;
% c
  shld(6,1) = onemssq*pt5;
  shld(6,2) =-s*onepr;
  shl(6,1) = onemssq*onepr*pt5;
% c
  shld(7,1) =-r*oneps;
  shld(7,2) = onemrsq*pt5;
  shl(7,1) = onemrsq*oneps*pt5;
% c
  shld(8,1) =-onemssq*pt5;
  shld(8,2) =-s*onemr;
  shl(8,1) = onemssq*onemr*pt5;
% c
% c       interior node (lagrangian)
% c       --------------------------
  shld(9,1) =-two*r*onemssq;
  shld(9,2) =-two*s*onemrsq;
  shl(9,1) = onemrsq*onemssq;
% c
% c       correct midside nodes for interior node (lagrangian)
% c       ----------------------------------------------------
%   for k=5:8
%     for i=1:3
%       shl(k,i)=shl(k,i)-pt5*shl(9,i);
%     end
%   end
  shld(5:8,:)=shld(5:8,:)-pt5*ones(4,1)*shld(9,:);
  shl(5:8,1)=shl(5:8,1)-pt5*ones(4,1)*shl(9,1);
% c
% c       correct corner nodes
% c       --------------------
%   for i=1:3
%     shl(i,1)=shl(i,1)  -pt5*(shl(i,5)+shl(i,8))-pt25*shl(i,9);
%     shl(i,2)=shl(i,2)  -pt5*(shl(i,6)+shl(i,5))-pt25*shl(i,9);
%     shl(i,3)=shl(i,3)  -pt5*(shl(i,7)+shl(i,6))-pt25*shl(i,9);
%     shl(i,4)=shl(i,4) -pt5*(shl(i,8)+shl(i,7))-pt25*shl(i,9);
%   end
    shld(1,:) = shld(1,:) - pt5*(shld(5,:)+shld(8,:)) - pt25*shld(9,:);
    shld(2,:) = shld(2,:) - pt5*(shld(6,:)+shld(5,:)) - pt25*shld(9,:);
    shld(3,:) = shld(3,:) - pt5*(shld(7,:)+shld(6,:)) - pt25*shld(9,:);
    shld(4,:) = shld(4,:) - pt5*(shld(8,:)+shld(7,:)) - pt25*shld(9,:);
    shl(1,1) = shl(1,1) - pt5*(shl(5,1)+shl(8,1)) - pt25*shl(9,1);
    shl(2,1) = shl(2,1) - pt5*(shl(6,1)+shl(5,1)) - pt25*shl(9,1);
    shl(3,1) = shl(3,1) - pt5*(shl(7,1)+shl(6,1)) - pt25*shl(9,1);
    shl(4,1) = shl(4,1) - pt5*(shl(8,1)+shl(7,1)) - pt25*shl(9,1);
end %if

if bf == 1 

  if nel == 4

    onemrsq = one-r*r;
    onemssq = one-s*s;
    bubble(1) =-two*r*onemssq;
    bubble(2) =-two*s*onemrsq;
    bubble(3) = onemrsq*onemssq;

  elseif nel == 9

% %                 onemrsq=one-r^4;
% %                 onemssq=one-s^4;
% %                 bubble(1) = -four*r*r*r*onemssq;
% %                 bubble(2) = -four*s*s*s*onemrsq;
% %                 bubble(3) = onemrsq*onemssq;
%     bubble(1) = 32.d0*r*s*s*(-1.d0+r*r)*(-1.d0+s*s)+32.d0*r*r*r*s*s*(-1.d0+s*s);
%     bubble(2) = 32.d0*r*r*s*(-1.d0+r*r)*(-1.d0+s*s)+32.d0*r*r*s*s*s*(-1.d0+r*r);
%     bubble(3) = 16.d0*r*r*s*s*(-1.d0+r*r)*(-1.d0+s*s);
                onemrsq=one-r^4;
                onemssq=one-s^4;
                bubble(1) = -four*r*r*r*onemssq;
                bubble(2) = -four*s*s*s*onemrsq;
                bubble(3) = onemrsq*onemssq;
                bubble(1) = bubble(1) + 32.d0*r*s*s*(-1.d0+r*r)*(-1.d0+s*s)+32.d0*r*r*r*s*s*(-1.d0+s*s);
                bubble(2) = bubble(2) + 32.d0*r*r*s*(-1.d0+r*r)*(-1.d0+s*s)+32.d0*r*r*s*s*s*(-1.d0+r*r);
                bubble(3) = bubble(3) + 16.d0*r*r*s*s*(-1.d0+r*r)*(-1.d0+s*s);

  end %if

end %if
% c            
% c     Forming the Local Second Derivatives of Quadrilateral Element
% c    --------------------------------------------------------------

if der == 1

  shls(1,1) = zero;
  shls(1,2) = zero;
  shls(1,3) = pt25;
% c
  shls(2,1) = zero;
  shls(2,2) = zero;
  shls(2,3) =-pt25;
% c
  shls(3,1) = zero;
  shls(3,2) = zero;
  shls(3,3) = pt25;
% c
  shls(4,1) = zero;
  shls(4,2) = zero;
  shls(4,3) =-pt25;
% c
  if nel == 9
    onepr = one + r;
    onemr = one - r;
    oneps = one + s;
    onems = one - s;
% c
    onemrsq = one-r*r;
    onemssq = one-s*s;
% c
    shls(5,1) =-onems;
    shls(5,2) = zero;
    shls(5,3) = r;
% c
    shls(6,1) = zero;
    shls(6,2) =-onepr;
    shls(6,3) =-s;
% c
    shls(7,1) =-oneps;
    shls(7,2) = zero;
    shls(7,3) =-r;
% c
    shls(8,1) = zero;
    shls(8,2) =-onemr;
    shls(8,3) = s;
% c
% c        interior node (lagrangian)
    shls(9,1) =-two*onemssq;
    shls(9,2) =-two*onemrsq;
    shls(9,3) = four*r*s;
% c
% c        correct midside nodes for interior node (lagrangian)
%     for k = 5:8
%       for i = 1:3
%         shls(i,k) = shls(i,k)-pt5*shls(i,9);
%       end
%     end
    shls(5:8,:) = shls(5:8,:) - pt5*ones(4,1)*shls(9,:);
% c
% c        correct corner nodes
%     for i = 1:3
%       shls(i,1)=shls(i,1)-pt5*(shls(i,5)+shls(i,8))-pt25*shls(i,9);
%       shls(i,2)=shls(i,2)-pt5*(shls(i,6)+shls(i,5))-pt25*shls(i,9);
%       shls(i,3)=shls(i,3)-pt5*(shls(i,7)+shls(i,6))-pt25*shls(i,9);
%       shls(i,4)=shls(i,4)-pt5*(shls(i,8)+shls(i,7))-pt25*shls(i,9);
%     end
    shls(1,:)=shls(1,:)-pt5*(shls(5,:)+shls(8,:))-pt25*shls(9,:);
    shls(2,:)=shls(2,:)-pt5*(shls(6,:)+shls(5,:))-pt25*shls(9,:);
    shls(3,:)=shls(3,:)-pt5*(shls(7,:)+shls(6,:))-pt25*shls(9,:);
    shls(4,:)=shls(4,:)-pt5*(shls(8,:)+shls(7,:))-pt25*shls(9,:);
  end
% c        end second derivatives of quadrilateral element
end

end
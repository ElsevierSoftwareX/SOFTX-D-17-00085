function [shl,shld,shls,bubble] = shlt(c1,c2,nel,nen,der,bf)
% c
% c.... Program to calculate integration-rule weight, shape functions, and 
% c     shape fnctn 1st derivatives in the reference coordinate system, at a 
% c     given integration point "l", for a 3 or 6 node TRIANGULAR element         
% c                                                                            
% c         l    = current integration point counter from calling program
% c         lint = total no. of integration pts from calling program (1,4 or 9)
% c         nel  = total no. of nodes in element (3 or 6), from calling program
% c         ib   = flag for interior (0) or boundary (1-3) integration
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
% c         c1, c2, c3 = local element coordinates ("l1", "l2", "l3".)       
% c
% c.... Written by A Masud (Spring 1988)  Modified by S Cain (Fall 1996)
% c.... Modified by T. Truster (Fall 2009)
% c
% c      implicit real*8 (a-h,o-z)
%       implicit none
% c.... remove above card for single precision operation
% c
%       integer nel
%       logical der,bf
%       integer i,j
%       real*8 zero,pt1667,pt25,pt5,one,two,three,four,five,six 
%       real*8 c1,c2,c3,fpt5,eight,xnine,twelve,twent7
%       real*8 shl(3,nel),shls(3,nel),bubble(3)
% 
% c
% c.... define some constants (for feap)

shl = zeros(nen,1);
shld = zeros(nen,2);
shls = zeros(nen,3);
bubble = zeros(1,3);

zero   = 0.d0;
% pt1667 = 0.1667d0;
% pt25   = 0.25d0;
pt5    = 0.5d0;
one    = 1.0d0;
two    = 2.0d0;
three  = 3.0d0;
four   = 4.0d0;
% five   = 5.0d0;
% six    = 6.0d0;
twent7 = three * three * three;

% c    
% c     Forming the Local First Derivatives of Triangle Element.
% c     --------------------------------------------------------
c3 = one - c1 - c2;

shld(2,1) = one;
shld(2,2) = zero;
shl(2,1) = c1; % N2=r

shld(3,1) = zero;
shld(3,2) = one;
shl(3,1) = c2; % N3=s

shld(1,1) =-one;
shld(1,2) =-one;
shl(1,1) = c3; % N1=t=1-r-s

if nel == 6
    
    shld(5,1) = four * c2;
    shld(5,2) = four * c1;
    shl(5,1) = four * c1 * c2;

    shld(6,1) =-four * c2;
    shld(6,2) = four * (c3 - c2);
    shl(6,1) = four * c2 * c3;

    shld(4,1) = four * (c3 - c1);
    shld(4,2) =-four * c1;
    shl(4,1) = four * c3 * c1;
% c
% c     correct the corner nodes
%     for i=1:3
%         shl(1,i)=shl(1,i)-pt5*(shl(4,i)+shl(6,i));
%         shl(2,i)=shl(2,i)-pt5*(shl(4,i)+shl(5,i));
%         shl(3,i)=shl(3,i)-pt5*(shl(5,i)+shl(6,i));
%     end
    shld(1,:)=shld(1,:)-pt5*(shld(4,:)+shld(6,:));
    shld(2,:)=shld(2,:)-pt5*(shld(4,:)+shld(5,:));
    shld(3,:)=shld(3,:)-pt5*(shld(5,:)+shld(6,:));
    shl(1,1)=shl(1,1)-pt5*(shl(4,1)+shl(6,1));
    shl(2,1)=shl(2,1)-pt5*(shl(4,1)+shl(5,1));
    shl(3,1)=shl(3,1)-pt5*(shl(5,1)+shl(6,1));
    
end

%             if nel == 10   %has not been adjusted!!!!!
%             fpt5  = four + pt5
% 		  eight = four * two
% 		  xnine = three * three
% 		  twelve= three * four
% 
% 		  shl(1,1)= twent7*c1*c1/two - xnine*c1 + one
% 		  shl(2,1)= zero
% 		  shl(3,1)= fpt5*c1*c1*c1 - fpt5*c1*c1 + c1
% 
% 		  shl(1,2)= zero
% 		  shl(2,2)= twent7*c2*c2/two - xnine*c2 + one
% 		  shl(3,2)= fpt5*c2*c2*c2 - fpt5*c2*c2 + c2
% 
% 		  shl(1,3)= fpt5*(-(five+six)/xnine + four*(c1+c2)
%      &			     - three*(c1+c2)*(c1+c2))	   
% 		  shl(2,3)= fpt5*(-(five+six)/xnine + four*(c1+c2)
%      &			     - three*(c1+c2)*(c1+c2))
% 		  shl(3,3)= fpt5*c3*c3*c3 - fpt5*c3*c3 + c3
% 
% 		  shl(1,4)= fpt5*c2*(six*c1 - one)
% 		  shl(2,4)= fpt5*c1*(three*c1 - one)
% 		  shl(3,4)= fpt5*c1*c2*(three*c1 - one)
% 
% 		  shl(1,5)= fpt5*c2*(three*c2 - one)
% 		  shl(2,5)= fpt5*c1*(six*c2 - one)
% 		  shl(3,5)= fpt5*c1*c2*(three*c2 - one)
% 
% 		  shl(1,6)= fpt5*c2*(one - three*c2)
% 		  shl(2,6)= fpt5*(-xnine*c2*c2 + eight*c2
%      &		              - six*c1*c2 + c1 - one)
% 		  shl(3,6)= fpt5*c2*c3*(three*c2 - one)
% 
% 		  shl(1,7)= fpt5*c2*(six*(c1 + c2) - five)
% 		  shl(2,7)= fpt5*(three*c1*c1 + xnine*c2*c2
%      &		              - five* c1 - five*two*c2 + twelve*c1*c2 + two)
% 		  shl(3,7)= fpt5*c2*c3*(three*c3 - one)
% 
% 		  shl(1,8)= fpt5*(three*c2*c2 + xnine*c1*c1
%      &			      - five*c2 - five*two*c1 + twelve*c1*c2 + two)
% 		  shl(2,8)= fpt5*c1*(six*(c1 + c2) - five)
% 		  shl(3,8)= fpt5*c1*c3*(three*c3 - one)
% 
% 		  shl(1,9)= fpt5*(-xnine*c1*c1 + eight*c1
%      &		              - six*c1*c2 + c2 - one)
% 		  shl(2,9)= fpt5*c1*(one - three*c1)
% 		  shl(3,9)= fpt5*c1*c3*(three*c1 - one)
% 
% 		  shl(1,10)= twent7*c2*(c3 - c1)
% 		  shl(2,10)= twent7*c1*(c3 - c2)
% 		  shl(3,10)= twent7*c1*c2*c3
% 
% % c		correct the corner nodes
% % c		------------------------
% % c
% % c		do i = 1,3
% % c		     shl(i,1)=shl(i,1)
% % c     &		        -(two/three)*(shl(i,4) + shl(i,9))
% % c     &		        -(one/three)*(shl(i,5) + shl(i,8))
% % c		     shl(i,2)=shl(i,2)
% % c     &		        -(two/three)*(shl(i,5) + shl(i,6))
% % c     &		        -(one/three)*(shl(i,4) + shl(i,7))
% % c		     shl(i,3)=shl(i,3)
% % c     &		        -(two/three)*(shl(i,7) + shl(i,8))
% % c     &		        -(one/three)*(shl(i,6) + shl(i,9))
% % c		end do
% % c
%             end

if bf == 1

    bubble(1) = twent7*c2*(c3-c1);
    bubble(2) = twent7*c1*(c3-c2);
    bubble(3) = twent7*c1*c2*c3;

end
% c
% c     Forming the Local Second Derivatives of Triangle Element.
% c     ---------------------------------------------------------
% c

if der == 1

%             do j = 1,3
%             do i = 1,3
%                shls(i,j)= zero
%             end 
%             end 

    if nel == 6
        
        shls(5,1) = zero;
        shls(5,2) = zero;
        shls(5,3) = four;

        shls(6,1) = zero;
        shls(6,2) =-four*two;
        shls(6,3) =-four;

        shls(4,1) =-four*two;
        shls(4,2) = zero;
        shls(4,3) =-four;
% c
% c      correct the corner nodes
% c      ------------------------
% c
%     for i=1:3
%         shls(1,i)=shls(1,i)-pt5*(shls(4,i)+shls(6,i));
%         shls(2,i)=shls(2,i)-pt5*(shls(4,i)+shls(5,i));
%         shls(3,i)=shls(3,i)-pt5*(shls(5,i)+shls(6,i));
%     end
        shls(1,:) = shls(1,:)-pt5*(shls(4,:)+shls(6,:));
        shls(2,:) = shls(2,:)-pt5*(shls(4,:)+shls(5,:));
        shls(3,:) = shls(3,:)-pt5*(shls(5,:)+shls(6,:));
        
    end

%           if(nel.eq.10) then !has not been adjusted!!!!
% 		fpt5  = four + pt5
% 		eight = four * two
% 		xnine = three * three
% 		twelve= three * four
% 		twent7= three * three * three
% 
% 		shls(1,1)= fpt5*(six*c1 - two)
% 		shls(2,1)= zero
% 		shls(3,1)= zero
% 
% 		shls(1,2)= zero
% 		shls(2,2)= fpt5*(six*c2 - two)
% 		shls(3,2)= zero
% 
% 		shls(1,3)= fpt5*(four - six*(c1+c2))
% 		shls(2,3)= fpt5*(four - six*(c1+c2))
% 		shls(3,3)= fpt5*(four - six*(c1+c2))
% 
% 		shls(1,4)= twent7 * c2
% 		shls(2,4)= zero
% 		shls(3,4)= fpt5*(six*c1 - one)
% 
% 		shls(1,5)= zero
% 		shls(2,5)= twent7 * c1
% 		shls(3,5)= fpt5*(six*c2 - one)
% 
% 		shls(1,6)= zero
% 		shls(2,6)= fpt5*(two + six*(c3 - two*c2))
% 		shls(3,6)= fpt5*(one - six*c2)
% 
% 		shls(1,7)= twent7 * c2
% 		shls(2,7)= fpt5*(-twelve*c3
%      &			     +two*(one+three*c2))
% 		shls(3,7)= fpt5*(six*(c2 - c3) + one)
% 
% 		shls(1,8)= fpt5*(-twelve*c3+two*(one+three*c1))
% 		shls(2,8)= twent7 * c1
% 		shls(3,8)= fpt5*(six*(c1 - c3) + one)
% 
% 		shls(1,9)= fpt5*(six*(c3 - two*c1) + two)
% 		shls(2,9)= zero
% 		shls(3,9)= fpt5*(one - six*c1)
% 
% 		shls(1,10)= -twent7*two*c2
% 		shls(2,10)= -twent7*two*c1
% 		shls(3,10)= twent7*(c3-c1-c2)
% % c
% % c		correct the corner nodes
% % c		------------------------
% % c
% % c		do i = 1,3
% % c		     shls(i,1)=shls(i,1)
% % c     &		        -(two/three)*(shls(i,4) + shls(i,9))
% % c     &		        -(one/three)*(shls(i,5) + shls(i,8))
% % c		     shls(i,2)=shls(i,2)
% % c     &		        -(two/three)*(shls(i,5) + shls(i,6))
% % c     &		        -(one/three)*(shls(i,4) + shls(i,7))
% % c		     shls(i,3)=shls(i,3)
% % c     &		        -(two/three)*(shls(i,7) + shls(i,8))
% % c     &		        -(one/three)*(shls(i,6) + shls(i,9))
% % c		end do
% % c
%           end

end

end
function [w,r,s] = intpntq(l,lint,ib)


%       integer l,lint,ib
%       real*8 ra(100),sa(100),wa(100),ls(9),lt(9),lw(9),w
%       real*8 x1d(10),w1d(10)
%       real*8 g4(4), h4(4)
%       integer l1,i,j,k
%       real*8 zero,pt1667,pt25,pt5,pt6,one,two,three,four,five,six 
%       real*8 etyone,g,h,forpt8,thirty,thrtsx,seven,r,s
% 
% 		                  
ls = [-1.d0,1.d0,1.d0,-1.d0,0.d0,1.d0,0.d0,-1.d0,0.d0];
lt = [-1.d0,-1.d0,1.d0,1.d0,-1.d0,0.d0,1.d0,0.d0,0.d0];
lw = [25.d0,25.d0,25.d0,25.d0,40.d0,40.d0,40.d0,40.d0,64.d0];
% c
x1d = [-0.973906528517172d0,-0.865063366688985d0,...
       -0.679409568299024d0,-0.433395394129247d0,...
       -0.148874338981631d0, 0.148874338981631d0,...
	    0.433395394129247d0, 0.679409568299024d0,...
        0.865063366688985d0, 0.973906528517172d0];
w1d = [ 0.066671344308688d0, 0.149451349150581d0,...
        0.219086362515982d0, 0.269266719309996d0,...
        0.295524224714753d0, 0.295524224714753d0,...
        0.269266719309996d0, 0.219086362515982d0,...
        0.149451349150581d0, 0.066671344308688d0];
    
GP = [-0.9324695142031520278123016, -0.6612093864662645136613996, -0.2386191860831969086305017, ...
    0.2386191860831969086305017, 0.6612093864662645136613996, 0.9324695142031520278123016];
GWgts = [0.1713244923791703450402961, 0.3607615730481386075698335, 0.4679139345726910473898703, ...
            0.4679139345726910473898703, 0.3607615730481386075698335, 0.1713244923791703450402961];
GP5 = [-0.90617984593866396000
-0.53846931010568311000
0.00000000000000000000
0.53846931010568311000
0.90617984593866396000];
GWgts5 = [0.23692688505618908000
0.47862867049936647000
0.56888888888888889000
0.47862867049936647000
0.23692688505618908000];
        
% GP = [-0.9491079123427585245261897, -0.7966664774136267395915539, -0.4058451513773971669066064, 0, ...
%     0.4058451513773971669066064, 0.7966664774136267395915539, 0.9491079123427585245261897];
% GWgts = [0.1294849661688696932706114, 0.2797053914892766679014678, 0.3818300505051189449503698, ...
%     0.4179591836734693877551020, 0.3818300505051189449503698, 0.2797053914892766679014678, 0.1294849661688696932706114];
% 
% c.... define some constants (for feap)
        ra = zeros(100,1);
        sa = zeros(100,1);
        wa = zeros(100,1);
        zero   = 0.d0;
%         pt1667 = 0.1667d0
%         pt25   = 0.25d0
        pt5    = 0.5d0;
        one    = 1.0d0;
        two    = 2.0d0;
        three  = 3.0d0;
        four   = 4.0d0;
        five   = 5.0d0;
        six    = 6.0d0;
% 
      if ib == 0
% 
      l1=sqrt(lint);
% c
% c     1x1 integration.
% c     ----------------
      if l1 == 1
      w     = four;
      ra(1) = zero;
      sa(1) = zero;
% !tjt      if (nel.eq.three) sa(1) = -one/three
      end    
% c
% c     2x2 integration.
% c     ----------------
      if l1 == 2
      g = one/sqrt(three);
      for i = 1:4
         w     = one;
         ra(i) = g*ls(i);
         sa(i) = g*lt(i);
      end
      end
% c
% c     3x3 integration.
% c     ----------------
      if l1 == 3
      pt6 = pt5+one/(two*five);
      etyone = three^four;
      g = sqrt(pt6);
      h = one/etyone;
      w = h*lw(l);
      for i = 1:9
         ra(i) = g*ls(i);
         sa(i) = g*lt(i);
      end
      end
% c
% c	4x4 integration.
% c	----------------
      if l1 == 4
	  forpt8 = four + four/five;
      thirty = five * six;
      thrtsx = six * six;
      seven  = one + six;
      g = sqrt(forpt8);
      h = sqrt(thirty)/thrtsx;
      g4(1) = sqrt((three + g)/seven);
      g4(4) = -g4(1);
      g4(2) = sqrt((three - g)/seven);
      g4(3) = -g4(2);
      h4(1) = pt5 - h;
      h4(2) = pt5 + h;
      h4(3) = pt5 + h;
      h4(4) = pt5 - h;
%
      i = zero;
      for j = 1:4
        for k = 1:4
	     i = i + 1;
	     wa(i)= h4(j)*h4(k);
	     ra(i)= g4(k);
	     sa(i)= g4(j);
        end
      end
       w = wa(l);
      end %if
% c
% c	5x5 integration.
% c	----------------
      if l1 == 5
      i = 0;
      for j = 1:l1
      for k = 1:l1  
      i = i + 1;
      if i == l
	   ra(i) = GP5(k);
	   sa(i) = GP5(j);
	   wa(i) = GWgts5(k)*GWgts5(j);	
      end
      end
      end
      w = wa(l);
      end
% c
% c	6x6 integration.
% c	----------------
      if l1 == 6
      i = 0;
      for j = 1:l1
      for k = 1:l1  
      i = i + 1;
      if i == l
	   ra(i) = GP(k);
	   sa(i) = GP(j);
	   wa(i) = GWgts(k)*GWgts(j);	
      end
      end
      end
      w = wa(l);
      end
% c
% c	10x10 integration.
% c	----------------
      if l1 == 10
      i = 1;
      for j = 1:10
      for k = 1:10
	   ra(i) = x1d(k);
	   sa(i) = x1d(j);
	   wa(i) = w1d(k)*w1d(j);	   
      i = i + 1;
      end
      end
      w = wa(l);
      end
% 
%       elseif (ib.eq.3) then
% c
% c	4x4 integration.
% c	----------------
%       if (lint .eq. 4) then
% 	  forpt8 = four + four/five
%       thirty = five * six
%       thrtsx = six * six
%       seven  = one + six
%       g = sqrt(forpt8)
%       h = sqrt(thirty)/thrtsx
%       g4(1) = sqrt((three + g)/seven)
%       g4(4) = -g4(1)
%       g4(2) = sqrt((three - g)/seven)
%       g4(3) = -g4(2)
%       h4(1) = pt5 - h
%       h4(2) = pt5 + h
%       h4(3) = pt5 + h
%       h4(4) = pt5 - h
% c
%       do 51 j = 1,4
% 	   wa(j)= h4(j)
% 	   ra(j)= -one
% 51	   sa(j)= g4(j)
%        w = wa(l)
%       endif
%       
%       elseif (ib.eq.4) then
% c
% c	4x4 integration.
% c	----------------
%       if (lint .eq. 4) then
% 	  forpt8 = four + four/five
%       thirty = five * six
%       thrtsx = six * six
%       seven  = one + six
%       g = sqrt(forpt8)
%       h = sqrt(thirty)/thrtsx
%       g4(1) = sqrt((three + g)/seven)
%       g4(4) = -g4(1)
%       g4(2) = sqrt((three - g)/seven)
%       g4(3) = -g4(2)
%       h4(1) = pt5 - h
%       h4(2) = pt5 + h
%       h4(3) = pt5 + h
%       h4(4) = pt5 - h
% c
%       do 61 j = 1,4
% 	   wa(j)= h4(j)
% 	   ra(j)= one
% 61	   sa(j)= g4(j)
%        w = wa(l)
%       endif
%       
      elseif ib == 1
    
      if lint == 1
% 	  forpt8 = four + four/five;
%       thirty = five * six;
%       thrtsx = six * six;
%       seven  = one + six;
%       g = sqrt(forpt8);
%       h = sqrt(thirty)/thrtsx;
      g4 = [0];
      h4 = 2;

%       for j = 1:3
        ra(1)= g4(1);
        sa(1)= -one;
        w = h4(1); %triangle coords are half of Guass coords
%       end
%        w = wa(l);
      end
          
      if lint == 2
      g = one/sqrt(three);
      for i = 1:2
         w     = one;
         ra(i) = g*ls(i);
         sa(i) = -one;
      end
      end
          
      if lint == 3
% 	  forpt8 = four + four/five;
%       thirty = five * six;
%       thrtsx = six * six;
%       seven  = one + six;
%       g = sqrt(forpt8);
%       h = sqrt(thirty)/thrtsx;
      g4 = [-sqrt(0.6) 0 sqrt(0.6)];
      h4 = (1/9)*[5 8 5];

      for j = 1:3
	   wa(j)= h4(j);
	   ra(j)= g4(j);
	   sa(j)= -one;
      end
       w = wa(l);
      end
% c
% c	4x4 integration.
% c	----------------
      if lint == 4
	  forpt8 = four + four/five;
      thirty = five * six;
      thrtsx = six * six;
      seven  = one + six;
      g = sqrt(forpt8);
      h = sqrt(thirty)/thrtsx;
      g4(1) = sqrt((three + g)/seven);
      g4(4) = -g4(1);
      g4(2) = sqrt((three - g)/seven);
      g4(3) = -g4(2);
      h4(1) = pt5 - h;
      h4(2) = pt5 + h;
      h4(3) = pt5 + h;
      h4(4) = pt5 - h;

      for j = 1:4
	   wa(j)= h4(j);
	   ra(j)= g4(j);
	   sa(j)= -one;
      end
       w = wa(l);
      end
% c
% c	5 points
% c	----------------
    if (lint == 6)
        g4 = [-1 -.5 0 .5 1];

        ra(l)= g4(l);
        sa(l)= -one;
        w = 1;
    end
    
% c
% c	10x10 integration.
% c	----------------
      if lint == 10
ra = x1d;
sa = -ones(10,1);
wa = w1d;
%       for j = 1:10
% 	   ra(j) = x1d(j);
% 	   sa(j) = -one;
% 	   wa(j) = w1d(j);	   
% 
% 
%       end
% c	rewind(15)
      w = wa(l);
      end
%       
%       elseif (ib.eq.2) then
% c
% c	4x4 integration.
% c	----------------
%       if (lint .eq. 4) then
% 	  forpt8 = four + four/five
%       thirty = five * six
%       thrtsx = six * six
%       seven  = one + six
%       g = sqrt(forpt8)
%       h = sqrt(thirty)/thrtsx
%       g4(1) = sqrt((three + g)/seven)
%       g4(4) = -g4(1)
%       g4(2) = sqrt((three - g)/seven)
%       g4(3) = -g4(2)
%       h4(1) = pt5 - h
%       h4(2) = pt5 + h
%       h4(3) = pt5 + h
%       h4(4) = pt5 - h
% c
%       do 81 j = 1,4
% 	   wa(j)= h4(j)
% 	   ra(j)= g4(j)
% 81	   sa(j)= one
%        w = wa(l)
%       endif
%       
      end %if
% 
      r = ra(l);
      s = sa(l);
% 
%       return
% 
%       end
function sw = int1d(l)
% 
% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2008: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c     Modification log                                Date (dd/mm/year)
% c       Original version                                    01/11/2006
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Gauss quadrature for 1-d element
% 
% c      Inputs:
% c         l     - Number of points
% 
% c      Outputs:
% c         sw(1,*) - Gauss points
% c         sw(2,*) - Gauss weights
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit  none
% 
%       include  'pconstant.h'
% 
%       integer   l
%       real*8    sw(2,*), t
% 
%       save
sw = zeros(2,5);
one3 = 1/3;

      if(l == 1) %then

        sw(1,1) = 0.0d0;
        sw(2,1) = 2.0d0;

      elseif(l == 2) %then

        sw(1,1) = -sqrt(1/3);
        sw(1,2) = -sw(1,1);
        sw(2,1) = 1.0d0;
        sw(2,2) = 1.0d0;

      elseif(l == 3) %then

        sw(1,1) = -sqrt(0.6);
        sw(1,2) = 0.0d0;
        sw(1,3) = -sw(1,1);
        sw(2,1) = 5/9;
        sw(2,2) = 8/9;
        sw(2,3) = sw(2,1);

      elseif(l == 4) %then

        t       =  sqrt(4.8);
        sw(1,1) = -sqrt((3.d0+t)/7.d0);
        sw(1,2) = -sqrt((3.d0-t)/7.d0);
        sw(1,3) = -sw(1,2);
        sw(1,4) = -sw(1,1);
        t       =  one3/t;                   % 1/3/t
        sw(2,1) =  0.5d0 - t;
        sw(2,2) =  0.5d0 + t;
        sw(2,3) =  sw(2,2);
        sw(2,4) =  sw(2,1);

      elseif(l == 5) %then

        t       =  1120.0d0;
        t       =  sqrt(t);

        sw(1,1) = (70.d0+t)/126.d0;
        sw(1,2) = (70.d0-t)/126.d0;

        t       =  1.d0/(15.d0 * (sw(1,2) - sw(1,1)));

        sw(2,1) = (5.0d0*sw(1,2) - 3.0d0)*t/sw(1,1);
        sw(2,2) = (3.0d0 - 5.0d0*sw(1,1))*t/sw(1,2);
        sw(2,3) =  2.0d0*(1.d0 - sw(2,1) - sw(2,2));
        sw(2,4) =  sw(2,2);
        sw(2,5) =  sw(2,1);

        sw(1,1) = -sqrt(sw(1,1));
        sw(1,2) = -sqrt(sw(1,2));
        sw(1,3) =  0.0d0;
        sw(1,4) = -sw(1,2);
        sw(1,5) = -sw(1,1);

% c     Compute points and weights

%       else

%         call gausspw(l,sw)

      end

      end

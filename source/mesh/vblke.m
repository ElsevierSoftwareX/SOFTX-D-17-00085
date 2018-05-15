function [ix,numel] = vblke(nr,ns,nt,ix,ni,ne,nen1,mat,ntyp,numel)

% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2002: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Generate a block of 3-d 8-node brick elements
% 
% c      Inputs:
% c         nr        - Number elements in 1-local coordinate dir.
% c         ns        - Number elements in 2-local coordinate dir.
% c         nt        - Number elements in 3-local coordinate dir.
% c         ni        - Initial node number for block
% c         ne        - Initial element number for block
% c         nf        - Final   element number for block
% c         nen1      - Dimension of ix array
% c         mat       - Material set number for block
% c         ntyp      - Element type for generations
% c                     10:  8-node hexahedron  elements
% c                     11:  4-node tetrahedron elements
% c                     12: 27-node hexahedron  elements
% c                     13: 10-node tetrahedron elements
% 
% c      Outputs:
% c         ix(*)     - Element nodal connection list for block
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit  none
% 
%       include  'cdata.h'
%       include  'cdat2.h'
%       include  'iofile.h'
%       include  'trdata.h'
% 
%       integer   ni,nf,ne,nen1,mat,ma,ntyp
%       integer   nr,ns,nt,nrs,i,j,k,l,m,n,dlayer, ninc
%       integer   ix(nen1,*),iq(27),it(10),ilr(*),nd(27),itl(4,6)
%       integer   itq(10,6)
%   
%       save

     ix = [ix zeros(nen1,numel-ne-1)];
     iq = zeros(27,1);
     it = zeros(10,1);
     nd = zeros(27,1);
     itl = [1,2,4,5; 2,3,4,8; 2,4,5,8; 2,6,3,8; 3,6,7,8; 5,6,2,8]';

     itq = [          1,2,4,5,  9, 21, 12, 17, 25, 23;
                      2,3,4,8, 10, 11, 21, 27, 26, 20;
                      2,4,5,8, 21, 23, 25, 27, 20, 16;
                      2,6,3,8, 18, 24, 10, 27, 22, 26;
                      3,6,7,8, 24, 14, 19, 26, 22, 15;
                      5,6,2,8, 13, 18, 25, 16, 22, 27]';

% c     Check generation order

      for i = 1:10
        it(i) = i;
      end % i
      for i = 1:27
        iq(i) = i;
      end % i
%       if(trdet<0.0d0)
%         for i = 1:4
%           iq(i+4) = i;
%           iq(i  ) = i+4;
%         end % i
%         if(ntyp==12)
%           for i = 9:12
%             iq(i+4) = i;
%             iq(i  ) = i+4;
%           end % i
%           iq(21) = 22;
%           iq(22) = 21;
%         end
%         i     = it(2);
%         it(2) = it(3);
%         it(3) = i;
%         if(ntyp==13)
%           i      = it( 5);
%           it( 5) = it( 7);
%           it( 7) = i;
%           i      = it( 9);
%           it( 9) = it(10);
%           it(10) = i;
%         end
%       end

      nrs = nr*ns;
      if(ntyp<=11)
        ninc  =  1;
        nd(1) = -1;
        nd(2) =  0;
        nd(3) =      nr;
        nd(4) = -1 + nr;
        nd(5) = -1      + nrs;
        nd(6) =           nrs;
        nd(7) =      nr + nrs;
        nd(8) = -1 + nr + nrs;
      elseif(ntyp<=13)
        ninc  =  2;
        nd( 1) = -1;
        nd( 2) =  1;
        nd( 3) =  1 + nr*2;
        nd( 4) = -1 + nr*2;
        nd( 5) = -1        + nrs*2;
        nd( 6) =  1        + nrs*2;
        nd( 7) =  1 + nr*2 + nrs*2;
        nd( 8) = -1 + nr*2 + nrs*2;
        nd( 9) =  0;
        nd(10) =  1 + nr;
        nd(11) =      nr*2;
        nd(12) = -1 + nr;
        nd(13) =             nrs*2;
        nd(14) =  1 + nr   + nrs*2;
        nd(15) =      nr*2 + nrs*2;
        nd(16) = -1 + nr   + nrs*2;
        nd(17) = -1        + nrs;
        nd(18) =  1        + nrs;
        nd(19) =  1 + nr*2 + nrs;
        nd(20) = -1 + nr*2 + nrs;
        nd(21) =      nr;
        nd(22) =      nr   + nrs*2;
        nd(23) = -1 + nr   + nrs;
        nd(24) =  1 + nr   + nrs;
        nd(25) =             nrs;
        nd(26) =      nr*2 + nrs;
        nd(27) =      nr   + nrs;
      end

% c     Compute element connections

%       if(dlayer>=0)
        ma = mat;
%       end
      nf = ne - 1;
      for k = 1:ninc:nt-1
%         if(dlayer==3)
%           ma = ilr(k);
%         end
        for j = 1:ninc:ns-1
%           if(dlayer==2)
%             ma = ilr(j);
%           end
          n = nr*(j-1 + ns*(k-1)) + ni;
          for i = 1:ninc:nr-1
%             if(dlayer==1)
%               ma = ilr(i);
%             end
            n = n + 1;

% c           8-node hexahedral elements

            if(ntyp==10)
              nf = nf + 1;
              ix(nen1,nf) = ma;
              for m = 1:8
                ix(iq(m),nf) = n + nd(m);
              end % m

% c           4-node tetrahedral elements

            elseif(ntyp==11)
              for l = 1:6
                nf = nf + 1;
                ix(nen1,nf) = ma;
                for m = 1:4
                  ix(it(m),nf) = n + nd(itl(m,l));
                end % m
              end % l

% c           27-node hexahedral elements

            elseif(ntyp==12)
              nf = nf + 1;
              ix(nen1,nf) = ma;
              for m = 1:27
                ix(iq(m),nf) = n + nd(m);
              end % m

% c           10-node tetrahedral elements

            elseif(ntyp==13)
              for l = 1:6
                nf = nf + 1;
                ix(nen1,nf) = ma;
                for m = 1:10
                  ix(it(m),nf) = n + nd(itq(m,l));
                end % m
              end % l

            end

            n = n + ninc - 1;

          end % i
        end % j
      end % k

      numel = nf;
      
      end

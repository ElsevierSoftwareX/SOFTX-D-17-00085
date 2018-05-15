function [ix,numel] = sblke6(nr,ns,ni,ne,ndm,nen1,nodinc,ntyp,nm,ma,ix)
% [ix,n] = sblke6(nr,ns,1,1,2,nen+1,0,ntyp,4 or 9)
% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2002: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: elements for 2-d problems
% 
% c         nm < 4 : Generates a line of elements
% c           ns = 1     2-node line
% c           ns = 2     3-node line
% c         nm > 3 : Generates a block of elements
% c           ntyp = 1   4-node quadrilaterals
% c           ntyp = 2   3-node triangles - diags ll to ur
% c           ntyp = 3   3-node triangles - diags ul to lr
% c           ntyp = 4   3-node triangles - diags
% c           ntyp = 5   3-node triangles - diags
% c           ntyp = 6   3-node triangles - diags union jack
% c           ntyp = 7   6-node triangles - diags ll to ur
% c           ntyp = 8   8-node quadrilaterals
% c           ntyp = 9   9-node quadrilaterals
% c           ntyp = 16 16-node quadrilaterals
% 
% c           ntyp =-1   3-node triangles - crossed pattern
% c           ntyp =-7   7-node triangles - diags ll to ur (bubble node)
% 
% c      Inputs:
% c         nr        - Number nodes in 1-local coordinate dir.
% c         ns        - Number nodes in 2-local coordinate dir.
% c         ni        - Initial node number for block
% c         ne        - Initial element number for block
% c         n         - Number of previous last node on block
% c         ndm       - Spatial dimension of mesh
% c         nen1      - Dimension of ix array
% c         nodinc    - Increment to node numbers at end of each line
% c         ntyp      - Block type
% c         nm        - Number of nodes on block
% c         mat       - Material set number for block
% c         ctype     - Type of block coordinates
% 
% c      Outputs:
% c         n         - Number of last node on block (added by 7-node tris).
% c         x(ndm,*)  - Nodal coordinates for block
% c         ix(*)     - Element nodal connection list for block
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit   none
% 
%       include   'cdata.h'
%       include   'cdat2.h'
%       include   'iofile.h'
%       include   'trdata.h'
% 
%       logical    ityp, pcomp
%       character  ctype*15
%       integer    nr,ns,ni,ne,ndm,nen1,nodinc,ntyp,mat,ma,dlayer
%       integer    i,j,n,me,np,nm,nn,n8,inc,ix(nen1,*),iq(9),it(6),ilr(*)
%       integer    ic(16),icr(16)
%       real*8     rr,sn,cn, o3, x(ndm,*)
% 
%       save
% 
%       data       o3 /0.333333333333333d0/
%       data       icr/ 4, 3, 2, 1,10, 9, 8, 7, 6, 5, 12,11,16,15,14,13/
% 
% c     Generate elements

%       if(dlayer.ge.0) then
%         ma = mat
%       endif

      iq = zeros(9,1);
      it = zeros(6,1);
      ic = zeros(16,1);
      if ntyp < 7
          numel = (nr-1)*(ns-1);
          if ntyp > 1
              numel = 2*numel;
          end
      else
          numel = (nr-1)*(ns-1)/4;
          if ntyp == 7
              numel = 2*numel;
          end
      end
%       ix = zeros(nen1,numel);
      
      if ne > 0
        for i = 1:9
          iq(i) = i;
        end % i
        for i = 1:16
          ic(i) = i;
        end % i
        for i = 1:6
          it(i) = i;
        end % i
%         if trdet < 0.0d0
%           if ntyp == 16
%             for i = 1:16
%               ic(i) = icr(i);
%             end % i
%           else
%             iq(1) = 4;
%             iq(2) = 3;
%             iq(3) = 2;
%             iq(4) = 1;
%             iq(5) = 7;
%             iq(7) = 5;
%             it(1) = 2;
%             it(2) = 1;
%             it(5) = 6;
%             it(6) = 5;
%           end
%         end
        me = ne - 1;

% c       Line generations

        if nm < 4
          inc = max(1,min(2,ns));
          nn  = ni;
          for i = 1:inc:nr-1
%             if dlayer == 1
%               ma = ilr(inc*i-inc+1);
%             end
            nn = nn + 1;
            me = me + 1;
            ix(nen1,me) = ma;
            ix(1,me)    = nn - 1;
            if inc == 2
              ix(3,me) = nn;
              nn       = nn + 1;
            end
            ix(2,me) = nn;
          end

% c       Block generations

        elseif ntyp>=0 || ntyp == -7
          inc = 1;
          if abs(ntyp)>=7
              inc = 2;
          end
          if ntyp == 16
              inc = 3;
          end
          for j = 1:inc:ns-1
%             if dlayer == 2
%               ma = ilr(inc*j-inc+1);
%             end
            if ntyp == 8 
              nn = (nr + nodinc*2 + (nr+1)/2)*(j-1)/2 + ni;
              n8 =  nn;
            else
              nn = (nr + nodinc)*(j-1) + ni;
            end
            for i = 1:inc:nr-1
%               if dlayer == 1
%                 ma = ilr(inc*i-inc+1);
%               end
              nn = nn + 1;
              me = me + 1;
              ix(nen1,me) = ma;
              if ntyp == 0
                if ndm == 1
                  ix(1,me)     = nn - 1;
                  ix(2,me)     = nn;
                else
                  ix(iq(1),me) = nn - 1;
                  ix(iq(2),me) = nn;
                  ix(iq(3),me) = nn + nr + nodinc;
                  ix(iq(4),me) = nn + nr - 1 + nodinc;
                end
              elseif abs(ntyp) == 7
                ix(it(1),me) = nn - 1;
                ix(it(4),me) = nn;
                ix(it(2),me) = nn + 1;
                ix(it(5),me) = nr+nodinc + nn;
                ix(it(6),me) = nr+nodinc + nn - 1;
                ix(it(3),me) = 2*(nr+nodinc) + nn - 1;
                me           = me + 1;
                ix(it(1),me) = nn + 1;
                ix(it(6),me) = nr+nodinc + nn;
                ix(it(4),me) = nr+nodinc + nn	+ 1;
                ix(it(3),me) = 2*(nr+nodinc) + nn - 1;
                ix(it(5),me) = 2*(nr+nodinc) + nn;
                ix(it(2),me) = 2*(nr+nodinc) + nn + 1;
                ix(nen1,me)  = ma;
                nn = nn + 1;
              elseif ntyp == 8
                ix(iq(1),me) = nn - 1;
                ix(iq(2),me) = nn + 1;
                ix(iq(3),me) = nr + nodinc + (nr+1)/2 + nodinc + nn + 1;
                ix(iq(4),me) = nr + nodinc + (nr+1)/2 + nodinc + nn - 1;
                ix(iq(5),me) = nn;
                ix(iq(6),me) = nr + nodinc +  n8 + 1;
                ix(iq(7),me) = nr + nodinc + (nr+1)/2 + nodinc + nn;
                ix(iq(8),me) = nr + nodinc +  n8;
                nn = nn + 1;
                n8 = n8 + 1;
              elseif ntyp == 9
                ix(iq(1),me) = nn - 1;
                ix(iq(2),me) = nn + 1;
                ix(iq(3),me) = 2*(nr+nodinc) + nn + 1;
                ix(iq(4),me) = 2*(nr+nodinc) + nn - 1;
                ix(iq(5),me) = nn;
                ix(iq(6),me) = nr+nodinc + nn + 1;
                ix(iq(7),me) = 2*(nr+nodinc) + nn;
                ix(iq(8),me) = nr+nodinc + nn - 1;
                ix(iq(9),me) = nr+nodinc + nn;
                nn = nn + 1;
              elseif ntyp == 16
                ix(ic( 1),me) = nn - 1;
                ix(ic( 2),me) = nn + 2;
                ix(ic( 3),me) = 3*(nr+nodinc) + nn + 2;
                ix(ic( 4),me) = 3*(nr+nodinc) + nn - 1;
                ix(ic( 5),me) = nn;
                ix(ic( 6),me) = nn + 1;
                ix(ic( 7),me) =    nr+nodinc  + nn + 2;
                ix(ic( 8),me) = 2*(nr+nodinc) + nn + 2;
                ix(ic( 9),me) = 3*(nr+nodinc) + nn + 1;
                ix(ic(10),me) = 3*(nr+nodinc) + nn;
                ix(ic(11),me) = 2*(nr+nodinc) + nn - 1;
                ix(ic(12),me) =    nr+nodinc  + nn - 1;
                ix(ic(13),me) =    nr+nodinc  + nn;
                ix(ic(14),me) =    nr+nodinc  + nn + 1;
                ix(ic(15),me) = 2*(nr+nodinc) + nn + 1;
                ix(ic(16),me) = 2*(nr+nodinc) + nn;
                nn = nn + 2;
              else
                ityp = (ntyp == 1)  || ...
                       (ntyp == 3 && mod(j,2) == 1) || ...
                       (ntyp == 4 && mod(j,2) == 0) || ...
                       (ntyp == 5 && mod(i+j,2) == 0) || ...
                       (ntyp == 6 && mod(i+j,2) == 1);
                if ityp == 1
                  ix(it(1),me) = nn - 1;
                  ix(it(2),me) = nn + nr + nodinc;
                  ix(it(3),me) = nn + nr + nodinc - 1;
                  me = me + 1;
                  ix(it(1),me) = nn - 1;
                  ix(it(2),me) = nn;
                  ix(it(3),me) = nn + nr + nodinc;
                  ix(nen1,me)  = ma;
                else
                  ix(it(1),me) = nn - 1;
                  ix(it(2),me) = nn;
                  ix(it(3),me) = nn + nr + nodinc - 1;
                  me = me + 1;
                  ix(it(1),me) = nn;
                  ix(it(2),me) = nn + nr + nodinc;
                  ix(it(3),me) = nn + nr + nodinc - 1;
                  ix(nen1,me)  = ma;
                end
              end
            end 
          end 
      elseif ntyp == -1
          for j = 1:ns-1
%             if dlayer == 2
%               ma = ilr(j);
%             end
            n  = (2*nr+nodinc-1)*(j-1) + ni;
            nn = n + 2*nr + nodinc - 1;
            inc = 2;
            if j == ns-1
                inc = 1;
            end
            for i = 1:nr-1
%               if dlayer == 1
%                 ma = ilr(i);
%               end
              n            = n  + 1;
              np           = nn + inc;
              me           = me + 1;
              ix(nen1,me)  = ma;
              ix(it(1),me) = n - 1;
              ix(it(2),me) = n + 1;
              ix(it(3),me) = n;
              me           = me + 1;
              ix(nen1,me)  = ma;
              ix(it(1),me) = n + 1;
              ix(it(2),me) = np;
              ix(it(3),me) = n;
              me           = me + 1;
              ix(nen1,me)  = ma;
              ix(it(1),me) = np;
              ix(it(2),me) = nn;
              ix(it(3),me) = n;
              me           = me + 1;
              ix(nen1,me)  = ma;
              ix(it(1),me) = nn;
              ix(it(2),me) = n - 1;
              ix(it(3),me) = n;
              n            = n  + 1;
              nn           = nn + inc;
            end
          end
        end
      end

% c     Set final element number

      numel = me;

      end
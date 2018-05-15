function x = sblkn(nr,ns,xll,ixl,dr,ds,ni,ndm,nodinc,nm,x,ctype,x0)
%ntyp,nm,ctype,prt,prth
%      * * F E A P * * A Finite Element Analysis Program

%....  Copyright (c) 1984-2002: Regents of the University of California
%                               All rights reserved

%-----[--.----+----.----+----.-----------------------------------------]
%      Purpose: Generate nodes and elements for 2-d problems

%         nm < 4 : Generates a line of elements
%           ns = 1     2-node line
%           ns = 2     3-node line
%         nm > 3 : Generates a block of elements
%           ntyp = 1   4-node quadrilaterals
%           ntyp = 2   3-node triangles - diags ll to ur
%           ntyp = 3   3-node triangles - diags ul to lr
%           ntyp = 4   3-node triangles - diags
%           ntyp = 5   3-node triangles - diags
%           ntyp = 6   3-node triangles - diags union jack
%           ntyp = 7   6-node triangles - diags ll to ur
%           ntyp = 8   8-node quadrilaterals
%           ntyp = 9   9-node quadrilaterals

%           ntyp =-1   3-node triangles - crossed pattern
%           ntyp =-7   7-node triangles - diags ll to ur (bubble node)

%      Inputs:
%         nr        - Number nodes in 1-local coordinate dir.
%         ns        - Number nodes in 2-local coordinate dir.
%         xl(ndm,*) - Block nodal coordinate array
%         ixl(*)    - Block nodal connection list
%         shp(3,*)  - Shape functions for block
%         dr        - 1-local coordinate increment
%         ds        - 2-local coordinate increment
%         ni        - Initial node number for block
%         ndm       - Spatial dimension of mesh
%         nodinc    - Increment to node numbers at end of each line
%         ntyp      - Block type
%         nm        - Number of nodes on block
%         ctype     - Type of block coordinates
%         prt       - Output generated data if true
%         prth      - Output title/header data if true

%      Outputs:
%         n         - Final node number for block
%         x(ndm,*)  - Nodal coordinates for block
%-----[--.----+----.----+----.-----------------------------------------]
%       implicit  none
% 
%       include  'cdata.h'
%       include  'cdat2.h'
%       include  'iofile.h'
%       include  'trdata.h'
% 
%       logical   prt,prth, pcomp
%       character xh*6, ctype*15
%       integer   i,j,k,n, mct,me, nm, inc8
%       integer   nr,ns,nsn,ni,ndm,nodinc,ntyp, ixl(*)
%       real*8    rr,sn,cn, drh,dsh,dr,ds, xsj
%       real*8    xl(3,*),x(ndm,*),shp(3,*),shp1(2,3),xx(3),ss(2),tt(2)
% 
%       save
% 
%       data      xh /' coord'/

nel = 9;
ss = zeros(2,1);
xl = zeros(ndm,nel);
% x = zeros(ndm,nr*ns);

%       do k = 1,3
%         xx(k) = 0.0d0
%       end

% drh =  dr*0.5d0;
% dsh =  ds*0.5d0;
n   =  ni;
% mct =  0;
if(nm < 4)
    nsn = 1;
    ixs = [1;3;2];
    for i = 1:2
        for k = 1:ndm
            xl(k,ixs(i)) = xll(k,i);
        end
    end
    if ixl(3) == 0
        for k = 1:ndm
            xl(k,2) = (xl(k,1) + xl(k,3))/2;
        end
    else
        for k = 1:ndm
            xl(k,2) = xll(k,3);
        end
    end
else
    nsn = ns;
    for i = 1:4
        for k = 1:ndm
            xl(k,i) = xll(k,i);
        end
    end
    i = i + 1;
    if ixl(i) == 0
        for k = 1:ndm
            xl(k,5) = (xl(k,1) + xl(k,2))/2;
        end
    else
        for k = 1:ndm
            xl(k,i) = xll(k,i);
        end
    end
    i = i + 1;
    if ixl(i) == 0
        for k = 1:ndm
            xl(k,6) = (xl(k,2) + xl(k,3))/2;
        end
    else
        for k = 1:ndm
            xl(k,i) = xll(k,i);
        end
    end
    i = i + 1;
    if ixl(i) == 0
        for k = 1:ndm
            xl(k,7) = (xl(k,3) + xl(k,4))/2;
        end
    else
        for k = 1:ndm
            xl(k,i) = xll(k,i);
        end
    end
    i = i + 1;
    if ixl(i) == 0
        for k = 1:ndm
            xl(k,8) = (xl(k,1) + xl(k,4))/2;
        end
    else
        for k = 1:ndm
            xl(k,i) = xll(k,i);
        end
    end
    i = i + 1;
    if ixl(i) == 0
        for j = 1:ndm
            xl(j,9) = 0.50d0*(xl(j,5) + xl(j,6) + xl(j,7) + xl(j,8)) ...
                    - 0.25d0*(xl(j,1) + xl(j,2) + xl(j,3) + xl(j,4));
        end
    else
        for k = 1:ndm
            xl(k,i) = xll(k,i);
        end
    end
end
ss(2)   = -1.0;
for j = 1:nsn
    ss(1) = -1.0;
%     if(ntyp == 8 && mod(j,2) == 0)
%         inc8 = 2;
%     else
        inc8 = 1;
%     end
    for i = 1:inc8:nr
        if (nm > 3)
            xx = zeros(ndm,1);
            shl = shlq(ss(1),ss(2),nel,nel,0,0);
            for jj = 1:nel
                for k = 1:ndm
                    xx(k) = xx(k) + xl(k,jj) * shl(jj);
                end
            end % j
        else
%             xx = zeros(ndm,1);
%             rbasis = EvalGPbasisLagr1(ss(1),0,1,2);
%             inode = 0;
%             for ii = 1:3
%                 inode = inode + 1;
%                 for k = 1:ndm
%                     xx(k) = xx(k) + xl(k,inode) * rbasis(ii);
%                 end
%             end % i
        end
          if strcmp(ctype, 'pola')
            [sn,cn] = pdegree(xx(2));
            rr    = xx(1);
            xx(1) = x0(1) + rr*cn;
            xx(2) = x0(2) + rr*sn;
          end
        for k = 1:ndm
            x(k,n) = xx(k);
        end
        for k = 1:ndm
            x(k,n) = xx(k);
        end
%           if(prt) then
%             mct = mct + 1
%             if(mod(mct,50).eq.1) then
%               call prtitl(prth)
%               write(iow,2003) (k,xh,k=1,ndm)
%               if(ior.lt.0) then
%                 write(*,2003) (k,xh,k=1,ndm)
%               endif
%             endif
%             write(iow,2004) n,(x(k,n),k=1,ndm)
%             if(ior.lt.0) then
%               write(*,2004) n,(x(k,n),k=1,ndm)
%             endif
%           endif
%             n = n + 1;
%             if(nm > 3 && ntyp == -1 && i< nr && j < ns)
%             tt(1) = ss(1) + drh;
%             tt(2) = ss(2) + dsh;
%             call shp2d(tt,xl,shp,xsj,3,nm,ixl,.true.)
%             call cfunc(shp,xl,ixl,ndm,x(1,n))
%             if(ndm.ge.2 .and. pcomp(ctype,'pola',4)) then
%               call pdegree(x(2,n), sn,cn)
%               rr     = x(1,n)
%               x(1,n) = x0(1) + rr*cn
%               x(2,n) = x0(2) + rr*sn
%             endif
%             if(prt) then
%               mct = mct + 1
%               if(mod(mct,50).eq.1) then
%                 call prtitl(prth)
%                 write(iow,2003) (k,xh,k=1,ndm)
%               endif
%               write(iow,2004) n,(x(k,n),k=1,ndm)
%               if(ior.lt.0) then
%                 if(mod(mct,50).eq.1) then
%                   write(*,2003) (k,xh,k=1,ndm)
%                 endif
%                 write(*,2004) n,(x(k,n),k=1,ndm)
%               endif
%             endif
        n = n + 1;
        ss(1) = ss(1) + dr*inc8;
    end
    n = n + nodinc;
    ss(2) = ss(2) + ds;
end

% c     Formats
% 
% 2003  format(/'  N o d a l   C o o r d i n a t e s'//6x,'Node',5(i7,a6))
% 
% 2004  format(i10,1p,5e13.4)

end
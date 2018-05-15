function x = vblkn(nr,ns,nt,xl,x,ixl,dr,ds,dt,ni,ndm,ctype,numnp,x0)
% 
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
% c         xl(ndm,*) - Block nodal coordinate array
% c         ixl(*)    - Block nodal connection list
% c         dr        - 1-local coordinate increment
% c         ds        - 2-local coordinate increment
% c         dt        - 3-local coordinate increment
% c         ni        - Initial node number for block
% c         ndm       - Spatial dimension of mesh
% c         ctype     - Type of block coordinates
% c         prt       - Output generated data if true
% c         prth      - Output title/header data if true
% 
% c      Outputs:
% c         x(ndm,*)  - Nodal coordinates for block
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit  none
% 
%       include  'cdata.h'
%       include  'cdat2.h'
%       include  'iofile.h'
%       include  'trdata.h'
% 
%       logical   prt,prth,phd, pcomp
%       character xh*6, ctype*15
%       integer   ni,ndm,nr,ns,nt,i,j,k,l,m,n,mct, ixl(*)
%       real*8    dr,ds,dt, rr,sn2,cn2,sn3,cn3
%       real*8    ss(3),xl(3,*),x(ndm,*),xx(3)
% 
%       save

      ss = zeros(3,1);
%       xl = zeros(3,:);
      x = [x zeros(ndm,numnp-ni-1)];
%       xx = zeros(3,1);
%       data      xh/' coord'/

% c     Check that all corners of brick are defined

%       for k = 1:3
%         xx(k) = 0.0d0;
%       end % k

      for k = 1:8
        if(ixl(k)~=k) 
            return
        end
      end
      [ixl,xl] = bcor3d(ixl,xl);
      n = ni;
%       mct = 0;
      ss(3) = -1.0d0;
      for k = 1:nt
        ss(2) = -1.0d0;
        for j = 1:ns
          ss(1) = -1.0d0;
          for i = 1:nr

% c           Compute coordinates of node

            xx = xbcor3d(ss,xl);

% c           Convert coordinates if necessary

            if(strcmp(ctype,'pola')) %then
              [sn2,cn2] = pdegree(xx(2));
              rr    = xx(1);
              xx(1) = x0(1) + rr*cn2;
              xx(2) = x0(2) + rr*sn2;
              xx(3) = x0(3) + xx(3);
            elseif(strcmp(ctype,'sphe')) % then
              [sn2,cn2] = pdegree(xx(2));
              [sn3,cn3] = pdegree(xx(3));
              rr    = xx(1);
              xx(1) = x0(1) + rr*cn2*sn3;
              xx(2) = x0(2) + rr*sn2*sn3;
              xx(3) = x0(3) + rr*cn3;
            end %if

% c           Transform to global coordinates

            for m = 1:ndm
%               x(m,n) = xr(m)+tr(m,1)*xx(1)+tr(m,2)*xx(2)+tr(m,3)*xx(3)
                x(m,n) = xx(m);
            end

% c           Output point

%             if(prt) then
%                mct = mct + 1
%                phd = mod(mct,50).eq.1
%                call prtitl(prth.and.phd)
%                if(phd) write(iow,2000) (l,xh,l=1,ndm)
%                write(iow,2001) n,(x(l,n),l=1,ndm)
%                if(ior.lt.0) then
%                  if(phd) write(*,2000) (l,xh,l=1,ndm)
%                  write(*,2001) n,(x(l,n),l=1,ndm)
%                endif
%             endif
            n = n + 1;
            ss(1) = ss(1) + dr;
          end
          ss(2) = ss(2) + ds;
        end
        ss(3) = ss(3) + dt;
      end

end

function [ixl,xl] = bcor3d(ixl,xl)
% 
%       implicit   none
% 
%       integer    ixl(27), imid(12),amid(12),bmid(12)
%       real*8     xl(3,27)
% 
%       integer    i,j

      imid = [9,10,11,12, 13,14,15,16, 18,19,20,21];
      amid = [1, 2, 3, 4,  1, 2, 3, 4,  5, 6, 7, 8];
      bmid = [5, 6, 7, 8,  2, 3, 4, 1,  6, 7, 8, 5];

% c     Mid edge coordinates

      for i = 1:12
        if(ixl(imid(i))==0)
          for j = 1:3
            xl(j,imid(i)) = 0.5d0*(xl(j,amid(i)) + xl(j,bmid(i)));
          end % j
          ixl(i) = i;
        end
      end % i

% c     Bottom and top

      if(ixl(17)==0)
        for j = 1:3
          xl(j,17) = 0.50d0*(xl(j,13) + xl(j,14) + xl(j,15) + xl(j,16)) ...
                   - 0.25d0*(xl(j, 1) + xl(j, 2) + xl(j, 3) + xl(j, 4));
        end % j
        ixl(17) = 17;
      end

      if(ixl(22)==0)
        for j = 1:3
          xl(j,22) = 0.50d0*(xl(j,18) + xl(j,19) + xl(j,20) + xl(j,21)) ...
                   - 0.25d0*(xl(j, 5) + xl(j, 6) + xl(j, 7) + xl(j, 8));
        end% j
        ixl(22) = 22;
      end

% c     Mid-face

      if(ixl(23)==0)
        for j = 1:3
          xl(j,23) = 0.50d0*(xl(j,13) + xl(j, 9) + xl(j,10) + xl(j,18)) ...
                   - 0.25d0*(xl(j, 1) + xl(j, 2) + xl(j, 5) + xl(j, 6));
        end % j
        ixl(23) = 23;
      end

      if(ixl(24)==0)
        for j = 1:3
          xl(j,24) = 0.50d0*(xl(j,14) + xl(j,10) + xl(j,11) + xl(j,19)) ...
                   - 0.25d0*(xl(j, 2) + xl(j, 3) + xl(j, 6) + xl(j, 7));
        end % j
        ixl(24) = 24;
      end

      if(ixl(25)==0)
        for j = 1:3
          xl(j,25) = 0.50d0*(xl(j,15) + xl(j,11) + xl(j,12) + xl(j,20)) ...
                   - 0.25d0*(xl(j, 3) + xl(j, 4) + xl(j, 7) + xl(j, 8));
        end % j
        ixl(25) = 25;
      end

      if(ixl(26)==0)
        for j = 1:3
          xl(j,26) = 0.50d0*(xl(j,16) + xl(j,12) + xl(j, 9) + xl(j,21)) ...
                   - 0.25d0*(xl(j, 4) + xl(j, 1) + xl(j, 8) + xl(j, 5));
        end % j
        ixl(26) = 26;
      end

% c     Center node

      if(ixl(27)==0)
        for j = 1:3
          xl(j,27) = 0.25d0*(xl(j,13) + xl(j,14) + xl(j,15) + xl(j,16) ...
                           + xl(j,18) + xl(j,19) + xl(j,20) + xl(j,21) ...
                           + xl(j,23) + xl(j,24) + xl(j,25) + xl(j,26) ...
                           - xl(j, 1) - xl(j, 2) - xl(j, 3) - xl(j, 4) ...
                           - xl(j, 5) - xl(j, 6) - xl(j, 7) - xl(j, 8));

        end % j
        ixl(27) = 27;
      end

end

function x = xbcor3d(ss,xl)
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Compute shape functions and coordinates for each point
% 
% c      Inputs:
% c         ss(3)   - Natural coordinates for point
% c         xl(3,*) - Nodal coordinates for brick
% 
% c      Outputs:
% c         x(3)    - Cartesian coordinates for point
% c-----[--.----+----.----+----.-----------------------------------------]
% 
%       implicit  none
% 
%       integer   j,l, ix(27),iy(27),iz(27)
%       real*8    ss(3),xl(3,27),x(3)
%       real*8    lshp(3,3),shp

      x = zeros(3,1);
      lshp = zeros(3,3);

      ix = [1,3,3,1, 1,3,3,1, 1,3,3,1, 2,3,2,1,2, 2,3,2,1,2, 2,3,2,1,2];
      iy = [1,1,3,3, 1,1,3,3, 1,1,3,3, 1,2,3,2,2, 1,2,3,2,2, 1,2,3,2,2];
      iz = [1,1,1,1, 3,3,3,3, 2,2,2,2, 1,1,1,1,1, 3,3,3,3,3, 2,2,2,2,2];

      for j = 1:3
        lshp(1,j) = 0.5d0*ss(j)*(ss(j) - 1.d0);
        lshp(2,j) = (1.d0 - ss(j)*ss(j));
        lshp(3,j) = 0.5d0*ss(j)*(ss(j) + 1.d0);
      end % j

%       for j = 1:3
%         x(j) = 0.0d0;
%       end

      for l = 1:27
        shp = lshp(ix(l),1)*lshp(iy(l),2)*lshp(iz(l),3);
        for j = 1:3
          x(j) = x(j) + shp*xl(j,l);
        end
      end

end

% c$Id:$
%       subroutine seteq(id,irb,irbc,ixt,jnt,prt)
% 
% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2008: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c     Modification log                                Date (dd/mm/year)
% c       Original version                                    01/11/2006
% c       1.  Add array 213 in call to newlnum.               02/07/2007
% c       2.  Modify calls to setlagf, newlnum                13/07/2007
% c       3.  Add 'point' and 'p_point.h'                     23/08/2007
% c       4.  Add 'ip' (np(120)) to argument of 'pelink'      13/12/2007
% c       5.  Add 'elnk' (np(257)) to argument of pelink'     25/12/2007
% c       6.                Conversion to Matlab by TJT       29/04/2013
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Set equation numbers for solution
% 
% c      Inputs:
% c        id(ndf,*) - Boundary condition indicators
% c        irbc(nrbdof,*) - Rigid body boundary restraint codes
% c        ixt(*)    - Nodal rigid body number array
% c        jnt(6,*)  - Joint identifier
% c        ndf       - Number dof/node
% c        ndm       - Spatial dimension of problem
% c        numnn     - Number of nodes in mesh
% c        prt       - Flag, output results if true
% 
% c      Outputs:
% c        id(ndf,*) - Equation numbers for each dof.  Active dof
% c                    have positive numbers for equation, fixed
% c                    dof have negative numbers
% c        irb(*)    - Rigid body equation numbers
% c        jnt(6,*)  - Joint equations in position 6
% c        nee       - Number of active equations in problem
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit  none
% 
%       include  'cdata.h'
%       include  'mxsiz.h'
%       include  'part0.h'
%       include  'part7.h'
%       include  'pointer.h'
%       include  'p_point.h'
%       include  'rigid1.h'
%       include  'rjoint.h'
%       include  'sdata.h'
%       include  'comblk.h'
% 
%       logical   prt, setlagf, setvar, palloc
%       integer   n,nn,nad, i, j
%       integer   id(ndf,numnp), jnt(6,numjts), ixt(numnp)
%       integer   irb(nrbdof,nrbody),irbc(nrbdof,nrbody)
% 
%       save

%     Set equation numbers for all types of points

      neq  = 0;
      nad  = 0;
      for nn = 1:numnp
%         nn = mr(np(89)+n);
        for i = 1:ndf
%           if(ndfp(i) == npart) %then
            j = idFEAP(i,nn);
            if(j == 0) %then
              neq     = neq + 1;
              idFEAP(i,nn) = neq; %#ok<*SAGROW>
            elseif(j == 1)
              nad     = nad - 1;
              idFEAP(i,nn) = nad;
            elseif((j == -1000) || (j == -1001))
              idFEAP(i,nn) = 0;
            end
%           end
        end % i
      end % n

%     Link nodes from data

if numComp > 0
    plink
end

%     Reassign ids to prescribed dofs

nieq = -nad;
ModelDc = zeros(nieq, 1);
for i = 1:numnp
    for j = 1:ndf
        ni = idFEAP(j,i);
        if ni < 0 %inactive
            idFEAP(j,i) = -ni + neq;
            ModelDc(-ni) = idFEAPBC(j,i);
        end
    end
end

NDOFT = idFEAP';
clear('idFEAP');

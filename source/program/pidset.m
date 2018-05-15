%       subroutine pidset(ip,ie,iedof,id,nty,ix,nie,nen,nen1,ndf,
%      &                  numnp,numel,nummat)
% 
% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2008: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c     Modification log                                Date (dd/mm/year)
% c       Original version                                    21/09/2007
% c       1.                Conversion to Matlab by TJT       29/04/2013
% c       2.                Optimized, switching for -> :     30/04/2013
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Set final boundary restraints after ties/cbou, etc.
% 
% c      Inputs:
% c         ie(nie,*)      - Material set assembly information
% c         iedof(ndf,*,*) - Material set nodal assembly information
% c         id(ndf,*)      - Boundary condition and equation number array
% c         nty(*)         - Nodal type
% c         ix(nen1,*)     - Element nodal connection lists
% c         nie            - Dimension of ie array
% c         nen            - Maximum number of nodes/element
% c         nen1           - Dimension for ix array
% c         ndf            - Number dof/node
% c         numnp          - Number of nodes in mesh
% c         numel          - Number of elemenst in mesh
% c         nummat         - Number of material sets
% 
% c      Outputs:
% c         id(ndf,*)      - List of boundary restraints and unused dof's
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit   none
% 
%       include   'prflag.h'
%       include   'pointer.h'
%       include   'comblk.h'
% 
%       integer    nie,nen,nen1,ndf,numnp,numel,nummat
%       integer    n,i,j, ii,mg, ma
%       integer    ip(ndf,*),  ie(nie,*), iedof(ndf,nen,*), id(ndf,*)
%       integer    ix(nen1,*), nty(*)

%     Remove unused dof's using ie(nie,*) array

%       for n = 1:numnp
%         for j = 1:ndf
%           ip(j,n) = 0;
%         end % j
%       end % n
      ip = zeros(ndf,numnp);
      nty = zeros(numnp,1);

%     Check nodes on each element for active dof's

      for elem = 1:numel
        mg = ix(elem,nen1);

%       Loop over material sets

        for ma = 1:nummat
          if(ieFEAP(nie-2,ma) == mg) %then
            for i = 1:nen
              ii = ix(elem,i);
              if(ii > 0) %then
%                 for j = 1:ndf
%                   if(iedof(j,i,ma) > 0) %then
%                     ip(iedof(j,i,ma),ii) = 1;
%                   end
%                 end % j
                dofs = nonzeros(iedof(1:ndf,i,ma));
                ip(dofs,ii) = 1;
              end
            end % i
          end
        end % ma
      end % n

% %     Check for point mass, dampers, stiffness
% 
%       if(nmfl) then
%         call mshckpt(hr(np(86)),hr(np(87)),hr(np(88)),ip,ndf,numnp)
%       endif

%     Set b.c. restraints for unused dof's

%       for node = 1:numnp
%         for j = 1:ndf
%           if(ip(j,node) == 0) %then
%             idFEAP(j,node) = -1000;
%           else
%             idFEAP(j,node) = abs(idFEAP(j,node));
%           end
%         end % j
%       end % n
      idFEAP = abs(idFEAP);
%       dofs = find(ip==0);
%       idFEAP(dofs) = -1000;
      idFEAP(ip==0) = -1000;

%     Remove unused nodes - for graphics

%       for node = 1:numnp
%         ip(1,node) = 0;
%       end % n
      ip(1,1:numnp) = 0;

      for elem = 1:numel
%         for i = 1:nen
%           ii = ix(elem,i);
%           if(ii > 0) 
%             ip(1,ii) = 1;
%           end
%         end % i
        dofs = nonzeros(ix(elem,1:nen));
        ip(1,dofs) = 1;
      end % n

%     Set flat to indicate node is not used

%       for node = 1:numnp
%         if(ip(1,node) == 0) %then
%           nty(node) = -1;
%         end
%       end % n
%       dofs = find(ip(1,1:numnp)==0);
%       nty(dofs) = -1;
      nty(ip(1,1:numnp)==0) = -1;

%     Fix all unspecified coordinate dof's

%       for node = 1:numnp
%         if(nty(node) < 0) %then
%           for i = 1:ndf
%             idFEAP(i,node) = -1001;
%           end % i
%         end
%       end % n
      dofs = find(nty<0);
      idFEAP(1:ndf,dofs) = -1001;
      
      if max(idFEAP) < 0
          error('Error: zero nodes in the mesh are active: max(idFEAP) < 0')
      end
      

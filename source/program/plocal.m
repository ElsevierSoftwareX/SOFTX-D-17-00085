function [EGDOFTa, EGDOFTi, ELDOFTa, ELDOFTi] = plocal(id, ix, iedof, actnode, nen, ndf, neq)
% c$Id:$
%       subroutine plocal(ld,id,ix,ie,iedof,xl,ul,ule,tl,ub, x,f,u,ud,t,
%      &                  un,dun, nrot, rfl,rel, jsw)
% 
% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2008: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c     Modification log                                Date (dd/mm/year)
% c       Original version                                    01/11/2006
% c       1. Optimization & Conversion to Matlab by TJT       30/04/2013
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Set local arrays for each element
% 
% c      Inputs:
% c        id(*)    - Global equation numbers/boundary restraints
% c        ie(*)    - Element descriptor parameters
% c        iedof(*) - Element descriptor parameters
% c        x(*)     - Global nodal coordinates
% c        f(*)     - Global nodal forces/displacements
% c        u(*)     - Global nodal solution parameters
% c        ud(*)    - Global nodal rate parameters
% c        t(*)     - Global temp variables
% c        rfl      - Rigid body indicator
% c        jsw      - Switching parameter
% 
% c      Scratch
% c        ubl(*)   - Local array for boundary displacements
% 
% c      Outputs:
% c        ld(*,*)  - Element global equation numbers
% c        xl(*)    - Element nodal coordinates
% c        ul(*)    - Element nodal solution parameters
% c        ule(*)   - Element internal solution parameters
% c        tl(*)    - Element temp values
% c        ub(*)    - Element boundary displacement modify values
% c        un,dun   - Boundary modification indicators
% c        nrot(2)  - Number dof's with rotated directions
% c        rel      - Rigid element indicator
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit   none
% 
%       include   'c_tanfl.h'
%       include   'cdata.h'
%       include   'cdat1.h'
%       include   'complx.h'
%       include   'corset.h'
%       include   'crotas.h'
%       include   'ddata.h'
%       include   'eldata.h'
%       include   'mdata.h'
%       include   'rdata.h'
%       include   'rdat0.h'
%       include   'sdata.h'
%       include   'part0.h'
%       include   'part7.h'
%       include   'pointer.h'
%       include   'comblk.h'
% 
%       include   'p_int.h'
% 
%       logical    rfl,rel, rfln
%       integer    nrot(2), jsw, i,j,k, iid,ild
%       integer    ld(nst,*),id(ndf,numnp,*),ix(*),ie(*),iedof(ndf,*)
%       real*8     un(*),dun(*), eul(3), ang
%       real*8     xl(ndm,*),ul(ndf,nen,*),ule(*),tl(*), ub(*), ubl(20)
%       real*8     x(ndm,*),f(ndf,*),u(ndf,*),ud(*),t(*)
% 
%       save

EGDOFTa = zeros(1,ndf*nen);
EGDOFTi = zeros(1,ndf*nen);
ELDOFTa = zeros(1,ndf*nen);
ELDOFTi = zeros(1,ndf*nen);
aloc = 0;
iloc = 0;

% for i = 1:nen
%     
%     if(ix(i) > 0) %then
%         
%         for j = 1:ndf
%             
%             if(iedof(j,i) > 0) %then
%                 
%                 k = id(ix(i),iedof(j,i));
%                 if k <= neq && k > 0
%                     aloc = aloc+1;
%                     EGDOFTa(aloc) = k;
%                     ELDOFTa(aloc) = (i-1)*ndf + j;
%                 elseif k > neq
%                     iloc = iloc+1;
%                     EGDOFTi(iloc) = k - neq;
%                     ELDOFTi(iloc) = (i-1)*ndf + j;
%                 end
%                 
%             end
%             
%         end
%                   
%     end
%     
% end
        
for i = 1:length(actnode)
        
    node = actnode(i);
    
    for j = 1:ndf

        if(iedof(j,node) > 0) %then

            k = id(ix(node),iedof(j,node));
            if k <= neq && k > 0
                aloc = aloc+1;
                EGDOFTa(aloc) = k;
                ELDOFTa(aloc) = (node-1)*ndf + j;
            elseif k > neq
                iloc = iloc+1;
                EGDOFTi(iloc) = k - neq;
                ELDOFTi(iloc) = (node-1)*ndf + j;
            end

        end

    end
    
end

EGDOFTa = EGDOFTa(1:aloc);
EGDOFTi = EGDOFTi(1:iloc);
ELDOFTa = ELDOFTa(1:aloc);
ELDOFTi = ELDOFTi(1:iloc);

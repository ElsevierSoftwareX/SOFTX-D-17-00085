% c$Id:$
%       subroutine pmatin(tx,d,ul,xl,tl,s,p,idl,ie,iedof,lie,prt,prth)
% 
% c      * * F E A P * * A Finite Element Analysis Program
% 
% c....  Copyright (c) 1984-2008: Regents of the University of California
% c                               All rights reserved
% 
% c-----[--.----+----.----+----.-----------------------------------------]
% c     Modification log                                Date (dd/mm/year)
% c       Original version                                    01/11/2006
% c       1.  Modify the write 2006 record to avoid too much  19/06/2007
% c           information in the record
% c       2.  Increase number of allowable dofs to 30         05/07/2007
% c       3.  Add 'plm' for element multiplier partition      20/07/2007
% c       4.  Correct format 2006 -- remove 'a1/2x'           20/08/2007
% c       5.                Conversion to Matlab by TJT       19/04/2013
% c       6.                Optimized, switching for -> :     30/04/2013
% c-----[--.----+----.----+----.-----------------------------------------]
% c      Purpose: Data input routine for material parameters
% 
% c      Inputs:
% c         tx          - Option identifier
% c         prt         - Flag, print input data if true
% c         prth        - Flag, print title/header if true
% 
% c      Scratch:
% c         ul(*)       - Local nodal solution vector
% c         xl(*)       - Local nodal coordinate vector
% c         tl(*)       - Local nodal temperature vector
% c         s(*)        - Element array
% c         p(*)        - Element vector
% c         idl(*)      - Local degree of freedom integer data
% c         lie(ndf,*)  - Local dof assignment array
% 
% c      Outputs:
% c         ie(nie,*)   - Element descriptor data
% c         iedof(*,*,*) - Element nodal assembly data
% c         d(ndd,*)    - Material parameters generated by elements
% c-----[--.----+----.----+----.-----------------------------------------]
%       implicit  none
% 
%       include  'cdata.h'
%       include  'cdat1.h'
%       include  'chdata.h'
%       include  'comfil.h'
%       include  'eldata.h'
%       include  'erotas.h'
%       include  'hdata.h'
%       include  'iofile.h'
%       include  'iodata.h'
%       include  'iosave.h'
%       include  'pdata3.h'
%       include  'rigid1.h'
%       include  'rigid2.h'
%       include  'strnum.h'
%       include  'sdata.h'
% 
%       logical   pcomp,pinput,tinput,vinput,errck,prt,prth,doflg
%       character tx(2)*15,mtype*69,etype*20
%       integer   i,j, ii,il,is, ie(nie,*),iedof(ndf,nen,*),idl(*)
%       integer   lie(ndf,*)
%       real*8    d(ndd,*),ul(*),xl(*),tl(*),s(*),p(*), td(50)
% 
%       save
        
idl = zeros(ndf,1);
lie = zeros(ndf,nen+1);

% error check on global materials
for mg = 1:nummat
    errchk = find(ix(1:numel,nen1)==mg);
    if size(errchk,1) > 0
        errchk = find(MatTypeTable(1,1:nummat)==mg);
        if size(errchk,1) == 0
            errmsg = ['error in ix: global material mg=' num2str(mg) 'does not have a corresponding local material in MatTypeTable'];
            error(errmsg)
        end
    end
end


% Initialize default number of stresses per node/element; can be increased 
% by case isw=1 of element routines
if ndm == 2
npstr = 7;
nestr = 7;
elseif ndm == 3
npstr = 11;
nestr = 11;
elseif ndm == 1
npstr = 1;
nestr = 1;
else
npstr = 0;
nestr = 0;
end
if ndm == 2
    if ndf == 3
    numEn = 16;
    elseif ndf == 2
    numEn = 6;
    else
    numEn = 6;
    end
elseif ndm == 3
    if ndf == 4
    numEn = 30;
    elseif ndf == 3
    numEn = 12;
    else
    numEn = 6;
    end
elseif ndm == 1
    if ndf == 1
    numEn = 2;
    else
    numEn = 6;
    end
else
numEn = 6;
end

% error check on global materials
for mg = 1:nummat
    errchk = find(ix(1:numel,nen1)==mg);
    if size(errchk,1) > 0
        errchk = find(MatTypeTable(1,1:nummat)==mg);
        if size(errchk,1) == 0
            errmsg = ['error in ix: global material mg=' num2str(mg) 'does not have a corresponding local material in MatTypeTable'];
            error(errmsg)
        end
    end
end


%     Data input for material set ma

for ma = 1:nummat

    mg = MatTypeTable(1,ma); % Global material id; allows for multiple materials per element
    iel = MatTypeTable(2,ma);    % Element type id
    mateprop = MateT(ma,:);
    
    if mg < 1 || mg > nummat
        errmsg = ['error in MatTypeTable ma=' num2str(ma)];
        error(errmsg)
    end

%     Set material type for standard elements

    if(ieFEAP(nie-1,ma) ~= 0 && iel == 0) %then
        iel = ieFEAP(nie-1,ma);
    else
        ieFEAP(nie-2,ma) = mg; %#ok<*SAGROW>
        if(ieFEAP(nie-2,ma) <= 0)
            ieFEAP(nie-2,ma) = ma;
        end
    end

%     Set local dof flags for active/inactive

    if size(MatTypeTable,1) > 3
        
%       for j = 1:ndf
%         idl(j) = MatTypeTable(3+j,ma);
%       end % j
      idl = MatTypeTable(4:3+ndf,ma);

%     Check to see if degree of freedoms to be reassigned

%       reassignidl = 1;
%       for i = 1:ndf
%         if(idl(i) ~= 0) 
%           reassignidl = 0;
%         end
%       end % i
      reassignidl = nnz(idl);
      reassignidl = (reassignidl==0);

%     Reset all zero inputs

      if reassignidl
%         for i = 1:ndf
%           idl(i) = i;
%         end % i
        idl = (1:ndf)';
      end
      
    else
        
      idl = (1:ndf)';
        
    end

    ieFEAP(nie-1,ma) = iel;
%     for i = 1:ndf
%       ieFEAP(i,ma) = idl(i);
%     end
    ieFEAP(1:ndf,ma) = idl;

%     Set flags for number of history and stress terms

    mct  = 0;
    nh1  = 0;
    nh2  = 0;
    nh3  = 0;
    nlm  = 0;
    plm  = 0;
    istv = 0;
    istp = 0;
    iste = 0;
    istee = 0;

%     Obtain inputs from element routine

%     for j = 1:nen+1
%       for i = 1:ndf
%         lie(i,j) = i;
%       end % i
%     end % j
    lie = (1:ndf)'*ones(1,nen+1);

%     Get material input data element library (isw = 1)

%      call elmlib(d(1,ma),ul,xl,lie,tl,s,p,ndf,ndm,nst,iel,1)
    isw = 1;
    ElemRout

%     Check if dof values set by each node

%     doflg = 0;    % Check if mixed conditions exist
%     for i = 1:ndf
%       for j = 1:nen
%         if(lie(i,j+1) == 0) %then
%           doflg = 1;
%         end
%       end % j
%     end % i
    doflg = nnz(lie(:,2:nen+1));
    doflg = (doflg~=ndf*nen);

%     Set assembly information

    if(doflg) %then
      for i = 1:ndf
        for j = 1:nen
          if(lie(i,j+1) > 0) %then
            iedof(i,j,ma) = idl(i);
          else
            iedof(i,j,ma) = 0;
          end
        end % j
      end % i
    else
      for i = 1:ndf
        if(lie(i,1) > 0) %then
%           for j = 1:nen
%             iedof(i,j,ma) = idl(i);
%           end % j
          iedof(i,1:nen,ma) = idl(i);
        else
%           for j = 1:nen
%             iedof(i,j,ma) = 0;
%           end % j
          iedof(i,1:nen,ma) = 0;
        end
      end % i
    end

%     Set number of history terms

    if(nh1 > 0) %then
      ieFEAP(nie,ma) = nh1;
    else
      ieFEAP(nie,ma) = mct;
    end
    ieFEAP(nie-5,ma) = nh3;

%     Set maximum number of element plot variables

      npstr = max(npstr,istv);
    % Check if new size for nodal/elemental stresses/errors
      nestr = max(nestr,iste);
      numEn = max(numEn,istee);
    
end


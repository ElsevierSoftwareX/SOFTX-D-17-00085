% Assemble Quantities from Model Routine
%
% Tim Truster
% 06/04/2013
% UIUC

for elem = 1:numel
    
  for ma = 1:nummat
      
   if(ieFEAP(nie-2,ma) == ix(elem,nen1))
      
    %Extract patch material properties
    iel = MatTypeTable(2,ma); %iel   = ie(nie-1,ma); same thing;
    mateprop = MateT(ma,:);
    if iscell(mateprop) % allows for crystal plasticity or other combined material listings
        mateprop = mateprop{1};
    end
    
    %Record time of assembly
    if Compt == 1
        tic
    end
    
    %Determine element size parameters
    nel = nnz(ix(elem,1:nen));
    nelS = getnelP(nel,ndm,nelS3,nelS4,nelS6,nelS9);
    nst = nen*ndf;
    
    %Extract  nodal coordinates
    
    ElemFlag = ix(elem,1:nen);
    actnode = find(ElemFlag>0);
    xl = zeros(ndm,nen);
    xl(1:ndm,actnode) = NodeTable(ElemFlag(actnode),1:ndm)';

    [EGDOFTa, EGDOFTi, ELDOFTa, ELDOFTi] = plocal(NDOFT, ElemFlag, squeeze(iedof(:,:,ma)), actnode, nen, ndf, neq);
    
    %Extract patch solution values
    ul = zeros(ndf, nen);
    ul(ELDOFTa) = ModelDx(EGDOFTa)';
    ul(ELDOFTi) = gBC(EGDOFTi)';
    
    ElemRout

    %Assemble Element contribution to Model Quantity
    
    for k = 1:nel
        node = ElemFlag(k);
        Eareas(node) = Eareas(node) + ElemS(k,npstr+1); %#ok<SAGROW>
    end
    
    for stres = 1:npstr
    
    for k = 1:nel
        node = ElemFlag(k);
        StreList2(node, stres) = StreList2(node, stres) + ElemS(k,stres)*ElemS(k,npstr+1); %#ok<SAGROW>
    end
    
    end
    
   end
    
  end % ma
    
end % elem
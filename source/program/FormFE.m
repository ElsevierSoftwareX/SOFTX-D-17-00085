% Assemble Quantities from Model Routine
%
% Tim Truster
% 7/2009
% UIUC
%
% NOTE 02/11/2014: for dynamic analyses with linear elements, the stiffness
% and mass matrix must be kept separate in order to shorten the calculation
% time. Thus, in the element routine mass is handled by isw=5 and stiffness
% by isw=3, and the% results are combined within the main program in Mdd11 
% and Kdd11.
% However, for nonlinear analyses the FEAP-standard can be used where
% K and M are combined together as the Mstar matrix. The code assumes that
% the entire static and dynamic contribution is computed by isw=3 and then
% assembled into Kdd11.
% This has been updated for transient = 1,2,5
% transient=3 still assumes separate matrices for M and K

% Initialize Model-level arrays
switch isw%Task Switch
    
    case 1 %Get Material Properties
        
    case 3 %Get Stiffness, Force
        Kdd11 = sparse(Ksdd(:,1),Ksdd(:,2),0,neq,neq);
        Kdf1 = sparse(Ksdf(:,1),Ksdf(:,2),0,neq,nieq);
        Kfd = sparse(Ksdf(:,2),Ksdf(:,1),0,nieq,neq);
        Kff = sparse(Ksff(:,1),Ksff(:,2),0,nieq,nieq);
        AssemQuant = 'AssemStifForc';
        Fd1 = Fext1;
        Fd3 = zeros(nieq,1);
    case 6 %Get Force
        hflgu = 1;
        h3flgu = 1;
        AssemQuant = 'AssemForc';
        Fd1 = Fext1;
        Fd3 = zeros(nieq,1);
    case 21 %Get Stiffness
        Kdd11 = sparse(Ksdd(:,1),Ksdd(:,2),0,neq,neq);
        Kdf1 = sparse(Ksdf(:,1),Ksdf(:,2),0,neq,nieq);
        Kfd = sparse(Ksdf(:,2),Ksdf(:,1),0,nieq,neq);
        Kff = sparse(Ksff(:,1),Ksff(:,2),0,nieq,nieq);
        AssemQuant = 'AssemStif';
    case 26
        AssemQuant = 'AssemEStre';
end

for elem = 1:numel
    
  for ma = 1:nummat
      
   if(ieFEAP(nie-2,ma) == ix(elem,nen1))
      
    %Extract patch material properties
    iel = MatTypeTable(2,ma); %iel   = ie(nie-1,ma); same thing;
    mateprop = MateT(ma,:);
    
    %Record time of assembly
    if Compt == 1
        tic
    end
    
    % Determine element size parameters
    nel = nnz(ix(elem,1:nen));
    nst = nen*ndf;
    
    % Extract nodal coordinates
    
    ElemFlag = ix(elem,1:nen);
    actnode = find(ElemFlag>0);
    xl = zeros(ndm,nen);
    xl(1:ndm,actnode) = NodeTable(ElemFlag(actnode),1:ndm)';

    % Determine global to local equation numbers
    [EGDOFTa, EGDOFTi, ELDOFTa, ELDOFTi] = plocal(NDOFT, ElemFlag, squeeze(iedof(:,:,ma)), actnode, nen, ndf, neq);
    
    %Extract patch solution values
    ul = zeros(ndf, nen);
    ul(ELDOFTa) = ModelDx(EGDOFTa)';
    ul(ELDOFTi) = gBC(EGDOFTi)';
    
    ElemRout
  
    %Assemble Element contribution to Model Quantity

%     run(AssemQuant)
    evalin('caller',[AssemQuant ';']);
    
    if Compt == 1
        t = toc;
        fprintf('Element %i time to assemble: %3.4f.\n',elem,t)
    end
    
   end %if ma
    
  end % ma
    
end % elem

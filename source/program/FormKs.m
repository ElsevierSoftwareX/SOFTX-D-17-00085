%FormKs
% Create sparsity pattern for stiffness matrix to conserve memory

Ksdd = zeros(numel*(ndf*nen)^2,2);
Ksdf = zeros(numel*(ndf*nen)^2,2);
Ksff = zeros(numel*(ndf*nen)^2,2);
sinddd = 0;
sinddf = 0;
sindff = 0;

for elem = 1:numel
    
    %Determine element size parameters
    nel = nnz(ix(elem,1:nen));
    nst = nel*ndf;
    
    %Extract element nodal coordinates
    ElemFlag = ix(elem,1:nel);
    actnode = find(ElemFlag>0);

    %Compute and Assemble Patch Stiffness
%     EDOFT = LocToGlobDOF(ElemFlag, NDOFT, nel, ndf);
    [EGDOFTa, EGDOFTi, ELDOFTa, ELDOFTi] = plocal(NDOFT, ElemFlag, squeeze(iedof(:,:,ma)), actnode, nen, ndf, neq);

    %Assemble Element contribution to Model Quantity

    AssemSparse
    
end

Ksdd = sortrows(Ksdd(1:sinddd,:),[1 2]);
Ksdd = unique(Ksdd,'rows');
Ksdf = sortrows(Ksdf(1:sinddf,:),[1 2]);
Ksdf = unique(Ksdf,'rows');
Ksff = sortrows(Ksff(1:sindff,:),[1 2]);
Ksff = unique(Ksff,'rows');

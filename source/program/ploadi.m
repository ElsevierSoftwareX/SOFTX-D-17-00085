% 04/30/2013

%Get Loads
Fc1 = zeros(neq, 1);
Fc1np = zeros(neq, 1);
Fcount = 0;

AssemQuant = 'AssemLoad';
isw = -1;
for FEload = 1:numSL
    
    nodeA = SurfacesL(FEload,1);
    nodeB = SurfacesL(FEload,2);
    elem = SurfacesL(FEload,3);
    edge = SurfacesL(FEload,4);
    traction = SurfacesL(FEload,5:7);
    
    nel = nnz(ix(elem,1:nen));
    nst = nel*ndf;
    
    %Extract patch nodal coordinates
    ElemFlag = ix(elem,1:nen);
    actnode = find(ElemFlag>0);
    xl = zeros(ndm,nen);
    xl(1:ndm,actnode) = NodeTable(ElemFlag(actnode),1:ndm)';
    
    %Extract patch material properties
    ma = ix(elem,nen1);
    mateprop = MateT(ma,:);
    iel = MatTypeTable(2,ma);

    %Compute and Assemble Patch Stiffness
%     EDOFT = LocToGlobDOF(ElemFlag, NDOFT, nel, ndf);
%     [EGDOFTa, EGDOFTi, ELDOFTa, ELDOFTi] = LocToGlobDOF2(ElemFlag, NDOFT, nel, ndf, neq);
    [EGDOFTa, EGDOFTi, ELDOFTa, ELDOFTi] = plocal(NDOFT, ElemFlag, squeeze(iedof(:,:,ma)), actnode, nen, ndf, neq);
    
    ElemRout

    %Assemble Element contribution to Model Quantity

    run(AssemQuant)
    
end

% Nodal loads
for i = 1:numNodalF
    node = NodeLoad(i,1);
    dir = NodeLoad(i,2);
    if dir > ndf
        errmsg = ['dof ID exceeds ndf for Nodalload=' num2str(i)];
        error(errmsg)
    end
    force = NodeLoad(i,3);
    dof = NDOFT(node,dir);
    if dof <= neq
        Fc1(dof) = Fc1(dof) + force;
        Fcount = Fcount + 1;
    end
end

ModelDx = zeros(neq,1);

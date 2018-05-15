% Demonstration of Gmsh reader/writer for 2d quadrilateral mesh.
% Domain: 2x1 rectangle
% Loading: Prescribed displacement of 0.2 on right edge.
%   CZM couplers between top and bottom elements
%
% Last revision: 05/07/2018 TJT

clear
% clc

Gmshfile = 'Solid2d.msh';
ndm = 2;
GmshInputReader

MateT = zeros(2,3);
MateT(1,:) = [100 .25 1];
MateT(2,:) = [100 .25 1];

% Insert CZM elements
numnpCG = numnp;
numelCG = numel;
nen_bulk = 4;
InterTypes = [0 0
              1 0];
DEIProgram2

numSI = 0;
for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        numSI = numSI + numSIi;
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                7,0,[100000 3 0.2],MatTypeTable,MateT);
        end
    end
end

% Update BC along left side of upper block
Nsetholder{3} = UpdateNodeSet(1,RegionOnElement,ElementsOnNodeNum,ElementsOnNode,ElementsOnNodeDup,Nsetholder{3},3);
NodeBC = [Nsetholder{1}; Nsetholder{2}; Nsetholder{3}; Nsetholder{4}];
NodeBC(1:3,2) = 2; % y-direction homogeneous displacement BC
NodeBC(4:6,2) = 1; % x-direction homogeneous displacement BC
NodeBC(7:9,2) = 1; % x-direction homogeneous displacement BC
NodeBC(10:12,2) = 2; % y-direction prescribed displacement BC
NodeBC(10:12,3) = 0.06; % change magnitude of prescribed displacement for Matlab model
numBC = size(NodeBC,1);

ProbType = [numnp numel nummat 2 2 nen];

% Write output file
GmshOut = 'Solid2dPlusCZM.msh';
DGCZMflag = 1; % turn on addition of CZM stuff
updateSolid = 1; % overwrite the connectivity with the separated materials
% NodesCZM = [(numnpCG+1:numnp)' Coordinates(numnpCG+1:numnp,:)]; % new duplicated nodes
ElsetCZM{1} = (numelCG+1:numel)'; % new element set for CZM
NodesOnElementCZM{1} = NodesOnElement(ElsetCZM{1},1:nen); % new CZM elements
eltypeCZM{1,1} = -1; % element type
eltypeCZM{2,1} = 3; % Material number; can also be an ACTIVE, existing material name
Nsetflag = 1;
NewNsetholder{1} = [16 17 18];
GmshInputWriter
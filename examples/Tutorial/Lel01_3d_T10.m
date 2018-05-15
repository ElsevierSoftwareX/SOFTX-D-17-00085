% Test for quadratic wedge CZ element.
% Domain: two cubes
% Loading: Nodal displacements on right face.
%
% Last revision: 10/28/2017 TJT

clear
% clc

nen = 10;
xl = [1 0 0 0
      2 4 0 0
      4 0 2 0
      3 4 2 0
      5 0 0 2
      6 4 0 2
      8 0 2 2
      7 4 2 2];
[Coordinates,NodesOnElement,~,numnp,numel] = block3d('cart',4,2,2,1,1,1,13,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';
RegionOnElement = [1 1 1 1 1 1 2 2 2 2 2 2]';
nodexm = find(abs(Coordinates(:,1)-0)<1e-9); %rollers at x=0
nodexp = find(abs(Coordinates(:,1)-4)<1e-9); %prescribed u_x at x=2
nodeym = find(abs(Coordinates(:,2)-0)<1e-9); %rollers at y=0
nodezm = find(abs(Coordinates(:,3)-0)<1e-9); %rollers at z=0
NodeBC = [nodexm 1*ones(length(nodexm),1) zeros(length(nodexm),1)
          nodeym 2*ones(length(nodeym),1) zeros(length(nodeym),1)
          nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodezm 3*ones(length(nodezm),1) zeros(length(nodezm),1)];
numBC = length(NodeBC);

MatTypeTable = [1 2
                1 1];
MateT = [1 1]'*[100 0.25 1];
nummat = 2;
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 0;
SEHist = 0;

% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
InterTypes = [0 0
              1 0]; % only put CZM between the element edges between materials 1-2
DEIProgram3

% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateNodeSet(0,RegionOnElement,ElementsOnNodeNum,...
                               ElementsOnNode,ElementsOnNodeDup,NodeBCCG,numBCCG);

numSI = numCL;
numelCG = numel;
nen_bulk = nen;
SurfacesI = zeros(0,8);
numSI = 0;
for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
        numSI = numSI + numSIi;
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,3,numel,nummat,6, ...
                7,0,[500],MatTypeTable,MateT);
        end
    end
end

ProbType = [numnp numel nummat 3 3 nen];

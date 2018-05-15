% Patch test for rectangular domain of T3 elements with DG couplers along
% interfaces between regions. User can modify the elements belonging to
% each region.
% Domain: 2x1 rectangle
% Loading: Prescribed displacement of 0.1 on right edge.
%
% Last revision: 12/09/2015 TJT

clear
% clc

nen = 3;
nel = 3;
% Mesh with 6x6 tiling
nu = 6;
nv = 6;

Coordinates = [1 0 0
             2 2 0
             4 0 1
             3 2 1];
type = 'cart';
rinc = nu;
sinc = nv;
node1 = 1;
elmt1 = 1;
mat = 1;
rskip = 0;
btype = 2;
[Coordinates,NodesOnElement,RegionOnElement,numnp,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,Coordinates,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

% Boundary conditions
nodexm = find(abs(Coordinates(:,1)-0)<1e-9); %rollers at x=0
nodexp = find(abs(Coordinates(:,1)-2)<1e-9); %prescribed u_x at x=2
nodeym = find(abs(Coordinates(:,2)-0)<1e-9); %rollers at y=0
NodeBC = [nodexm 1*ones(length(nodexm),1) zeros(length(nodexm),1)
          nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodeym 2*ones(length(nodeym),1) zeros(length(nodeym),1)];
numBC = length(NodeBC);

RegionOnElement(1:2) = 3;
RegionOnElement(3:4) = 2;
RegionOnElement(7:8) = 2;
nummat = 3;
MatTypeTable = [1 2 3; 1 1 1];
MateT = [1 1 1]'*[190e3 0.3 1];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
InterTypes = [0 0 0
              1 0 0
              1 1 0]; % only put CZM between the element edges between materials 1-2
DEIProgram2

% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateNodeSet(maxel,0,RegionOnElement,ElementsOnNodeNum,...
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
%         SurfacesIi = squeeze(ElementsOnFacetInt(1:numSIi,1:4,matI));
%         SurfacesI(numSI+1:numSI+numSIi,:) = squeeze(ElementsOnFacetInt(1:numSIi,1:8,matI));
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
        numSI = numSI + numSIi;
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormDG(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                8,0,[0],MatTypeTable,MateT);
        end
    end
end

ProbType = [numnp numel nummat 2 2 nen];

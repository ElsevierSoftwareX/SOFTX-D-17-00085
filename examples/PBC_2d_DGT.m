% Axial test of Periodic Boundary Conditions with CZ couplers, triangular
% elements
% Domain: 4x4 rectangle block
% Loading: Prescribed axial displacement.
%
% Last revision: 03/25/2017 TJT

clear
% clc

nen = 4;
nel = 4;

numc = 4;2;1;
xl = [1 0 0
      2 numc 0
      4 0 numc
      3 numc numc];
type = 'cart';
rinc = numc;
sinc = numc;
node1 = 1;
elmt1 = 1;
mat = 1;
rskip = 0;
btype = 1;
[Coordinates,NodesOnElement,~,numnp,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

% Modify regions
RegionOnElement = [1 1 2 2 2 2 1 1 1 1 2 2 2 2 1 1 1 1 2 2 2 2 1 1 1 1 2 2 2 2 1 1]';
nummat = 2;
MatTypeTable = [1 2
                1 1];
MateT = [100 0.25 1
         100 0.25 1];

% Boundary conditions
FIX = 1;
RIGHT = (numc+1); %x
TOP = (numc+1)*(numc)+1; %y
TOPRIGHT = TOP + RIGHT - 1; %xy
NodeBC = [FIX 1 0
          FIX 2 0
          RIGHT 1 0.01
          RIGHT 2 0
          TOP 1 0
          TOP 2 0
          ];
numBC = size(NodeBC,1);

% Create periodic boundary conditions
dx = 1;
dy = numc+1;
dxy = TOP - 1;
PBCListx = [(RIGHT:dy:TOPRIGHT)' (FIX:dy:TOP)' RIGHT*ones(dy,1) FIX*ones(dy,1)]; %y
% remove repeats
RIGHTface = 2:dy;
PBCListx = PBCListx(RIGHTface,:);
PBCListy = [(TOP:dx:TOPRIGHT)' (FIX:dx:RIGHT)' TOP*ones(dy,1) FIX*ones(dy,1)]; %x
% remove repeats
TOPface = 1:dy;
TOPface = setdiff(TOPface,dy);
TOPface = setdiff(TOPface,1);
PBCListy = PBCListy(TOPface,:);
PBCList = [PBCListx; PBCListy];

% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
usePBC = 1; % flag to turn on keeping PBC
InterTypes = [0 0
              1 0]; % only put CZM between the element edges between materials 1-2
DEIProgram2

numSI = numCL;
numelCG = numel;
nen_bulk = nen;
SurfacesI = zeros(0,8);
numSI = 0;
CZstiff = 1;50000;
PBCListNew = zeros(0,5);
numPBCnew = 0;
TieNodesNew = zeros(2,2);
NodesOnLinkNew = zeros(4,numnp);
NodesOnLinknumNew = zeros(numnp,1);
for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        numSIi = numEonPBC(matI);
        if numSIi > 0 % Create PBC pairs first
            if InterTypes(mat2,mat1) > 0% then make PBC-CZ couplers
            locF = FacetsOnPBCNum(matI):(FacetsOnPBCNum(matI+1)-1);
            facs = FacetsOnPBC(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            [NodesOnElement,RegionOnElement,~,numnp,numel,nummat,MatTypeTable,MateT,Coordinates,...
                PBCListNew,numPBCnew,NodesOnLinkNew,NodesOnLinknumNew,TieNodesNew] = ...
             FormPBCCZ(PBCListNew,numPBCnew,NodesOnLinkNew,NodesOnLinknumNew,TieNodesNew,...
                    SurfacesIi,NodesOnElement,NodesOnElementCG,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numnp,numel,nummat,6, ...
                    7,0,CZstiff,PBCList,TieNodes,NodesOnLink,NodesOnLinknum,MatTypeTable,MateT);
            % Then form regular CZ couplers
            numSIi = numEonF(matI) - numSIi;
            locF = FacetsOnIntMinusPBCNum(matI):(FacetsOnIntMinusPBCNum(matI+1)-1);
            facs = FacetsOnIntMinusPBC(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            numSI = numSI + numSIi;
            [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
             FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                    7,0,CZstiff,MatTypeTable,MateT);
            else % just form PBC pairs
            locF = FacetsOnPBCNum(matI):(FacetsOnPBCNum(matI+1)-1);
            facs = FacetsOnPBC(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            [PBCListNew,numPBCnew,NodesOnLinkNew,NodesOnLinknumNew,TieNodesNew] = ...
            FormPBC(PBCListNew,numPBCnew,NodesOnLinkNew,NodesOnLinknumNew,TieNodesNew,SurfacesIi,...
                NodesOnElement,NodesOnElementCG,Coordinates,numSIi,2,PBCList, ...
                TieNodes,NodesOnLink,NodesOnLinknum);
            end
        elseif InterTypes(mat2,mat1) > 0 % just make CZ couplers
            numSIi = numEonF(matI);
            locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
            facs = FacetsOnInterface(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            numSI = numSI + numSIi;
            [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
             FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                    7,0,CZstiff,MatTypeTable,MateT);
        end
    end
end

% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateMasterBC(TieNodes,TieNodesNew,NodeBCCG,numBCCG);

[PBCList,numPBC,TieNodes] = CleanPBC(TieNodes,2,PBCListNew,numPBCnew,TieNodesNew);

% now actually add the Lagrange multiplier nodes
[Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen] = AddLMNodes(PBCList,Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen);

ProbType = [numnp numel nummat 2 2 nen];
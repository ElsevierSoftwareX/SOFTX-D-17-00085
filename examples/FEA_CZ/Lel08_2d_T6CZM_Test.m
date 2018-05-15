% Rectangular domain of T6 elements with CZ couplers along
% interfaces between regions. User can modify the elements belonging to
% each region.
% Domain: 2x1 rectangle
% Loading: Prescribed displacement of 0.1 on right edge.
%
% Last revision: 10/28/2017 TJT

clear
% clc

nen = 6;
nel = 6;
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
btype = 7;
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

RegionOnElement(1:6:13) = 3;
RegionOnElement(3:6:15) = 2;
RegionOnElement(5:6:17) = 1;
RegionOnElement(2:6:14) = 3;
RegionOnElement(4:6:16) = 2;
RegionOnElement(6:6:18) = 1;
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
ndm = 2;
[NodesOnElement,RegionOnElement,Coordinates,numnp,Output_data] ...
    = DEIPFunction(InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm);


% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateNodeSetFunction(0,RegionOnElement,Output_data,NodeBCCG,numBCCG);

% Insert CZ couplers
% CZ element stiffness
CZprop = 50000;

[NodesOnElement,RegionOnElement,Coordinates,numnp,nen,numel,nummat,RegionsOnInterface,MateT,MatTypeTable...
] = InterFunction(1,InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,Output_data,7,CZprop,MateT,MatTypeTable);

ProbType = [numnp numel nummat 2 2 nen];

% Patch test for prismatic domain of B8 elements with DG couplers along
% interfaces between regions. User can modify the elements belonging to
% each region.
% Domain: 2x1x3 rectangle block
% Loading: Prescribed displacement of 0.1 on right edge.
%
% Last revision: 10/28/2017 TJT

clear
% clc

nen = 8;
nel = 8;

xl = [1 0 0 0
      2 2 0 0
      4 0 1 0
      3 2 1 0
      5 0 0 3
      6 2 0 3
      8 0 1 3
      7 2 1 3];
[Coordinates,NodesOnElement,RegionOnElement,numnp,numel] = block3d('cart',6,6,6,1,1,1,10,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

% Boundary conditions
nodexm = find(abs(Coordinates(:,1)-0)<1e-9); %rollers at x=0
nodezp = find(abs(Coordinates(:,3)-3)<1e-9); %prescribed u_x at x=2
nodeym = find(abs(Coordinates(:,2)-0)<1e-9); %rollers at y=0
nodezm = find(abs(Coordinates(:,3)-0)<1e-9); %rollers at z=0
NodeBC = [nodexm 1*ones(length(nodexm),1) zeros(length(nodexm),1)
          nodezp 3*ones(length(nodezp),1) .1*ones(length(nodezp),1)
          nodeym 2*ones(length(nodeym),1) zeros(length(nodeym),1)
          nodezm 3*ones(length(nodezm),1) zeros(length(nodezm),1)];
numBC = length(NodeBC);

nummat = 3;
RegionOnElement(1:6*6*2) = 3;
RegionOnElement(6*6*2+1:6*6*4) = 2;
% RegionOnElement(31:36) = 2;
MatTypeTable = [1 2 3
                1 1 1];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

MateT = [1 1 1]'*[190e3 0.3 1];

% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
InterTypes = [0 0 0
              1 0 0
              1 1 0]; % only put CZM between the element edges between materials 1-2
ndm = 3;
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

ProbType = [numnp numel nummat 3 3 nen];

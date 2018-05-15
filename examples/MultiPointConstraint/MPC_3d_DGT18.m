% Axial test of MP Periodic Boundary Conditions with CZ couplers, tetrahedral
% elements, 8 grains, quadratic
% Domain: 4x4x4 rectangle block
% Loading: Prescribed axial displacement.
%
% Last revision: 10/28/2017 TJT

clear
% clc

nen = 10;
nel = 10;

numc = 8;2;1;
xl = [1 0 0 0
      2 numc 0 0
      4 0 numc 0
      3 numc numc 0
      5 0 0 numc
      6 numc 0 numc
      8 0 numc numc
      7 numc numc numc];
[Coordinates,NodesOnElement,~,numnp,numel] = block3d('cart',numc,numc,numc,1,1,1,13,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

% Modify regions
RegionOnElement = [1*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 1*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 3*ones(1,6) 3*ones(1,6) 4*ones(1,6) 4*ones(1,6) 3*ones(1,6) 3*ones(1,6) 4*ones(1,6) 4*ones(1,6) ...
                   1*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 1*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 3*ones(1,6) 3*ones(1,6) 4*ones(1,6) 4*ones(1,6) 3*ones(1,6) 3*ones(1,6) 4*ones(1,6) 4*ones(1,6) ...
                   5*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 5*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 7*ones(1,6) 7*ones(1,6) 8*ones(1,6) 8*ones(1,6) 7*ones(1,6) 7*ones(1,6) 8*ones(1,6) 8*ones(1,6) ...
                   5*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 5*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 7*ones(1,6) 7*ones(1,6) 8*ones(1,6) 8*ones(1,6) 7*ones(1,6) 7*ones(1,6) 8*ones(1,6) 8*ones(1,6) ]';
% RegionOnElement = [7*ones(1,6) 8*ones(1,6) 8*ones(1,6) 7*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 5*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 5*ones(1,6) 7*ones(1,6) 8*ones(1,6) 8*ones(1,6) 7*ones(1,6) ...
%                    3*ones(1,6) 4*ones(1,6) 4*ones(1,6) 3*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 1*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 1*ones(1,6) 3*ones(1,6) 4*ones(1,6) 4*ones(1,6) 3*ones(1,6) ...
%                    3*ones(1,6) 4*ones(1,6) 4*ones(1,6) 3*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 1*ones(1,6) 1*ones(1,6) 2*ones(1,6) 2*ones(1,6) 1*ones(1,6) 3*ones(1,6) 4*ones(1,6) 4*ones(1,6) 3*ones(1,6) ...
%                    7*ones(1,6) 8*ones(1,6) 8*ones(1,6) 7*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 5*ones(1,6) 5*ones(1,6) 6*ones(1,6) 6*ones(1,6) 5*ones(1,6) 7*ones(1,6) 8*ones(1,6) 8*ones(1,6) 7*ones(1,6) ...
%                    ]';
ix = randperm(numel);
NodesOnElement = NodesOnElement(ix,:);
RegionOnElement = RegionOnElement(ix);
nummat = 8;
MatTypeTable = [1 2 3 4 5 6 7 8
                1 1 1 1 1 1 1 1];
MateT = [100 0.25 1
         100 0.25 1
         100 0.25 1
         100 0.25 1
         100 0.25 1
         100 0.25 1
         100 0.25 1
         100 0.25 1];
     
% Boundary conditions
FIX = 1;
FRONT = (numnp-(numc+1)*(numc+1)+1); %z
RIGHT = (numc+1); %x
TOP = (numc+1)*(numc)+1; %y
TOPRIGHT = TOP + RIGHT - 1; %xy
FRONTRIGHT = FRONT + RIGHT - 1; %xz
TOPFRONT = FRONT + TOP - 1; %yz
TOPFRONTRIGHT = numnp; %yz
NodeBC = [FIX 1 0
          FIX 2 0
          FIX 3 0
%           FRONT 1 0
%           FRONT 2 0
%           FRONT 3 0.03
%           RIGHT 1 0.02
%           RIGHT 2 0
%           RIGHT 3 0
%           TOP 1 0
%           TOP 2 0.01
%           TOP 3 0
          ];
numBC = size(NodeBC,1);

% Create periodic boundary conditions
dx = 1;
dy = numc+1;
dz = dy*dy;
dxy = TOP - 1;
PBCListx = [(RIGHT:dy:TOPFRONTRIGHT)' (FIX:dy:TOPFRONT)' RIGHT*ones(dz,1) FIX*ones(dz,1)]; %yz
% remove repeats
RIGHTface = 2:dz;
PBCListx = PBCListx(RIGHTface,:);
PBCListy = zeros(dz,4); %xz
ind = 0;
TOP2 = TOP - 1;
FIX2 = 0;
for j = 1:dy
    for i = 1:dy
        TOP2 = TOP2 + 1;
        FIX2 = FIX2 + 1;
        ind = ind + 1;
        PBCListy(ind,:) = [TOP2 FIX2 TOP FIX];
    end
    TOP2 = TOP2 + TOP - 1;
    FIX2 = FIX2 + TOP - 1;
end
% remove repeats
TOPface = 1:dz;
TOPface = setdiff(TOPface,(dy:dy:dz));
TOPface = setdiff(TOPface,1);
PBCListy = PBCListy(TOPface,:);
PBCListz = [(FRONT:dx:TOPFRONTRIGHT)' (FIX:dx:TOPRIGHT)' FRONT*ones(dz,1) FIX*ones(dz,1)]; %xy
PBCListz = PBCListz(1:dz-dy,:);
% remove repeats
FRONTface = 1:dz;
FRONTface = setdiff(FRONTface,(dz-dy:dz));
FRONTface = setdiff(FRONTface,(dy:dy:dz-dy));
FRONTface = setdiff(FRONTface,1);
PBCListz = PBCListz(FRONTface,:);
PBCList = [PBCListx; PBCListy; PBCListz];
% PBCList = [PBCListx];
MPCListx = [PBCListx(:,1:2) ones(length(PBCListx),1)*[1 0 0]
            PBCListx(1,3:4) [1 0 0]];
MPCListy = [PBCListy(:,1:2) ones(length(PBCListy),1)*[0 1 0]
            PBCListy(1,3:4) [0 1 0]];
MPCListz = [PBCListz(:,1:2) ones(length(PBCListz),1)*[0 0 1]
            PBCListz(1,3:4) [0 0 1]];
MPCList = [MPCListx; MPCListy; MPCListz];


% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
numMPC = length(MPCList);
usePBC = 2; % flag to turn on keeping PBC
InterTypes = [0 0 0 0 0 0 0 0
              1 0 0 0 0 0 0 0
              1 1 0 0 0 0 0 0
              1 1 1 0 0 0 0 0
              1 1 1 1 0 0 0 0
              1 1 1 1 1 0 0 0
              1 1 1 1 1 1 0 0
              1 1 1 1 1 1 1 0]; % only put CZM between the element edges between materials 1-2
ndm = 3;
[NodesOnElement,RegionOnElement,Coordinates,numnp,Output_data,MPCList,numMPC] = DEIPFunction(InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,usePBC,numMPC,MPCList);


% Insert couplers; use extended DG mesh with ghost elements so that
% couplers appear properly on the domain boundary
% CZ element stiffness
CZprop = 50;1;
% MPC spring element properties
pencoeff = 1e9;
CornerXYZ = [0.000000 0.000000 0.000000
             1.000000 0.000000 0.000000
             0.000000 1.000000 0.000000];

[NodesOnElement,RegionOnElement,Coordinates,numnp,nen,numel,nummat,RegionsOnInterface,MateT,MatTypeTable,NodeTypeNum,numMPC,MPCList...
] =InterFunction(3,InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,Output_data,7,CZprop,MateT,MatTypeTable,usePBC,numMPC,MPCList,...
pencoeff,CornerXYZ);


% Applied displacements instead of forces
NodeLoad2 = [NodeTypeNum(2)+ndm 1 .01
            NodeTypeNum(2)+ndm 2 0
            NodeTypeNum(2)+ndm 3 0
            NodeTypeNum(2)+ndm+1 1 0
            NodeTypeNum(2)+ndm+1 2 .01
            NodeTypeNum(2)+ndm+1 3 0
            NodeTypeNum(2)+ndm+2 1 0
            NodeTypeNum(2)+ndm+2 2 0
            NodeTypeNum(2)+ndm+2 3 .01];
NodeBC = [NodeBC; NodeLoad2];
numBC = length(NodeBC);
% % Nodal forces allow rotation of cube
% NodeLoad = [NodeTypeNum(2)+ndm 1 1
%             NodeTypeNum(2)+ndm 2 0
%             NodeTypeNum(2)+ndm 3 0
%             NodeTypeNum(2)+ndm+1 1 0
%             NodeTypeNum(2)+ndm+1 2 1
%             NodeTypeNum(2)+ndm+1 3 0
%             NodeTypeNum(2)+ndm+2 1 0
%             NodeTypeNum(2)+ndm+2 2 0
%             NodeTypeNum(2)+ndm+2 3 1];
% numNodalF = length(NodeLoad);

ProbType = [numnp numel nummat 3 3 nen];

% plotNodeCont3(Coordinates+Node_U_V*100, Node_U_V(:,1), NodesOnElement, 2,1:64*6)
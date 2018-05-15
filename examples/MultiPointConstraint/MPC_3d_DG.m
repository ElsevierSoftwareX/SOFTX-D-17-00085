% Axial test of MP Periodic Boundary Conditions with CZ couplers, 2 grains.
% Domain: 4x4x4 rectangle block
% Loading: Prescribed shear displacement.
%
% Last revision: 10/28/2017 TJT

clear
% clc

nen = 8;
nel = 8;

numc = 4;2;1;
xl = [1 0 0 0
      2 numc 0 0
      4 0 numc 0
      3 numc numc 0
      5 0 0 numc
      6 numc 0 numc
      8 0 numc numc
      7 numc numc numc];
[Coordinates,NodesOnElement,~,numnp,numel] = block3d('cart',numc,numc,numc,1,1,1,10,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

% Modify regions
% RegionOnElement = [1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
%                    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
%                    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
%                    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ]';
RegionOnElement = [1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 ...
                   1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 ...
                   1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 ...
                   1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 ]';
% ix = randperm(numel);
% % ix = [42,54,40,1,19,52,38,59,58,45,16,48,28,63,6,35,22,2,17,32,44,23,36,39,11,51,53,34,46,4,50,21,18,12,41,47,13,26,55,20,62,8,31,33,57,3,25,9,30,29,56,14,60,15,64,37,43,5,61,24,27,7,49,10];
% % ix = [59,35,28,27,55,48,63,57,32,4,5,51,37,41,13,49,10,14,8,6,43,22,39,36,12,17,25,64,56,47,34,16,40,29,53,3,20,26,33,19,42,15,44,45,46,24,23,60,30,38,9,61,52,18,7,62,1,50,21,11,31,2,58,54];
% % ix=[33,59,24,49,16,17,60,18,23,8,2,21,9,64,40,47,14,10,38,62,22,20,41,5,37,15,26,43,58,56,29,46,7,35,50,51,48,19,28,52,45,11,1,55,13,39,30,12,63,44,25,3,61,34,31,6,53,42,57,27,54,32,4,36];
% % ix = [12,56,22,32,46,31,15,8,37,1,58,64,47,49,4,55,42,30,25,50,20,53,5,61,52,24,45,9,23,41,10,60,36,34,27,21,54,51,2,38,7,3,48,11,13,18,33,57,40,6,19,16,62,63,29,59,28,26,43,35,14,39,44,17];
% ix = [33,43,61,35,11,59,17,31,55,58,53,23,1,56,48,50,45,3,34,46,15,18,28,7,29,64,12,8,9,26,36,22,44,49,5,4,39,63,41,51,6,14,57,20,60,21,42,37,13,30,40,27,2,25,19,16,38,24,32,54,47,10,62,52];
% % ix = [26,2,55,47,4,17,27,45,19,36,51,9,64,34,61,15,54,40,39,14,33,18,5,58,28,6,25,46,12,63,3,44,50,16,8,49,22,41,59,52,42,21,53,48,11,57,35,60,43,20,24,7,30,56,13,10,62,23,38,31,1,29,37,32];
% NodesOnElement = NodesOnElement(ix,:);
% RegionOnElement = RegionOnElement(ix);
nummat = 2;
MatTypeTable = [1 2
                1 1];
MateT = [100 0.25 1
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
%           FRONT 3 0
%           RIGHT 1 0.01
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
InterTypes = [0 0
              1 0]; % only put CZM between the element edges between materials 1-2
ndm = 3;
[NodesOnElement,RegionOnElement,Coordinates,numnp,Output_data,MPCList,numMPC] = DEIPFunction(InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,usePBC,numMPC,MPCList);


% Insert couplers; use extended DG mesh with ghost elements so that
% couplers appear properly on the domain boundary
% CZ element stiffness
CZprop = 50000;1;
% MPC spring element properties
pencoeff = 1e9;
CornerXYZ = [0.000000 0.000000 0.000000
             1.000000 0.000000 0.000000
             0.000000 1.000000 0.000000];

[NodesOnElement,RegionOnElement,Coordinates,numnp,nen,numel,nummat,RegionsOnInterface,MateT,MatTypeTable,NodeTypeNum,numMPC,MPCList...
] =InterFunction(4,InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,Output_data,7,CZprop,MateT,MatTypeTable,usePBC,numMPC,MPCList,...
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

% plotMesh3(Coordinates,NodesOnElement,1,(1:64),(1:size(Coordinates,1))',[1 1 1 1 1])
% plotNodeCont3(Coordinates+Node_U_V*100, Node_U_V(:,1), NodesOnElement, 2,1:144)
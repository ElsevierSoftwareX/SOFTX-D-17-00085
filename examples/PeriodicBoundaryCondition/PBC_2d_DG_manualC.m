% Shear test of Periodic Boundary Conditions with CZ couplers; manual
% version for 4 regions, CZ only along vertical edges
% Domain: 4x4 rectangle block
% Loading: Prescribed shear displacement.
%
% Last revision: 02/14/2017 TJT

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
btype = 0;
[Coordinates,NodesOnElement,~,numnp,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

% Modify regions
RegionOnElement = [1 1 2 2 1 1 2 2 3 3 4 4 3 3 4 4 5 5 5 5 5 5 5 5]';
nummat = 5;
MatTypeTable = [1,2,3,4,5;1,1,1,1,7;0,0,0,0,0];
MateT = [100,0.250000000000000,1,0,0;100,0.250000000000000,1,0,0;100,0.250000000000000,1,0,0;100,0.250000000000000,1,0,0;2,1,4,4,1]; %50000]; %

% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

% Manual stuff
PBCList = [
           22 2 21 1
           23 3 21 1
           43 26 21 1
           24 4 21 1
           25 5 21 1
%            47 27 21 1
           29 6 27 1
           37 11 27 1
           40 16 27 1
           47 21 27 1
];
Coordinates = [Coordinates
               Coordinates([3 5 8 10 11 12 13 13 13 14 15 15 15 18 20 21 22 23 23 23 24 25 25 25],:)];
% Coordinates([27 29 37 40 47],1) = 5;
numnp = numnp + 24;
NodesOnElement = [NodesOnElement
                  8 3 26 28
                  13 8 28 32
                  18 13 32 39
                  23 18 39 43
                  10 5 27 29
                  15 10 29 37
                  20 15 37 40
                  25 20 40 47];
numel = numel + 8;
NodesOnElement(3,[1 4]) = [26 28];
NodesOnElement(7,[1 4]) = [28 32];
NodesOnElement(11,[1 4]) = [32 39];
NodesOnElement(15,[1 4]) = [39 43];

% now actually add the Lagrange multiplier nodes
[Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen] = AddLMNodes(PBCList,Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen);

% Boundary conditions
FIX = 1;
RIGHT = 27; %x
TOP = 21; %y
TOPRIGHT = 47; %xy
NodeBC = [FIX 1 0
          FIX 2 0
          RIGHT 1 0.01
          RIGHT 2 0
          TOP 1 0
          TOP 2 0
          ];
numBC = size(NodeBC,1);

ProbType = [numnp numel nummat 2 2 nen];

% Plotting
% plotNodeCont2(Coordinates+Node_U_V*100, Node_U_V(:,1), NodesOnElement, 2, 1:24, [1 1 1], 0,[3 4 6 9 0])
% Node_U_V(PBCList(:,1),:)-Node_U_V(PBCList(:,2),:)
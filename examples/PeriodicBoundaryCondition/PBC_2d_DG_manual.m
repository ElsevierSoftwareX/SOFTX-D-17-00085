% Shear test of Periodic Boundary Conditions with CZ couplers
% Domain: 4x4 rectangle block
% Loading: Prescribed shear displacement.
%
% Last revision: 02/12/2017 TJT

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
RegionOnElement = [1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 3 3 3 3 3 3 3 3]';
nummat = 3;
MatTypeTable = [1,2,3;1,1,7;0,0,0];
MateT = [100,0.250000000000000,1,0,0;100,0.250000000000000,1,0,0;2,1,4,4,1]; %50000]; %

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

% Manual stuff
PBCList = [PBCList
           34 26 21 1
           35 27 21 1];
Coordinates = [Coordinates
               Coordinates([2 4 7 9 12 14 17 19 22 24],:)];
numnp = numnp + 10;
NodesOnElement = [NodesOnElement
                  7 2 26 28
                  12 7 28 30
                  17 12 30 32
                  22 17 32 34
                  9 4 27 29
                  14 9 29 31
                  19 14 31 33
                  24 19 33 35];
numel = numel + 8;
NodesOnElement(2,[1 4]) = [26 28];
NodesOnElement(6,[1 4]) = [28 30];
NodesOnElement(10,[1 4]) = [30 32];
NodesOnElement(14,[1 4]) = [32 34];
NodesOnElement(4,[1 4]) = [27 29];
NodesOnElement(8,[1 4]) = [29 31];
NodesOnElement(12,[1 4]) = [31 33];
NodesOnElement(16,[1 4]) = [33 35];

% now actually add the Lagrange multiplier nodes
[Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen] = AddLMNodes(PBCList,Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen);

ProbType = [numnp numel nummat 2 2 nen];
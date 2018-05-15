% Patch test for subdivision of T10 elements into H8 elements
% Domain: 2x1x3 rectangle block
% Loading: Prescribed displacement of 0.1 on right edge.
%
% Last revision: 05/13/2017 TJT

clear
% clc

nen = 10;
nel = 10;

xl = [1 0 0 0
      2 2 0 0
      4 0 2 0
      3 2 2 0
      5 0 0 2
      6 2 0 2
      8 0 2 2
      7 2 2 2];
[Coordinates,NodesOnElement,RegionOnElement,numnp,numel] = block3d('cart',4,4,4,1,1,1,13,xl,nen);
Coordinates = Coordinates';
NodesOnElement = NodesOnElement';

nummat = 3;
RegionOnElement(1:6) = 3;
% RegionOnElement(13:18) = 2;
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
InterTypes = zeros(3,3); % only put CZM between the element edges between materials 1-2
DEIProgram3

% Split each tetrahedral element into 4 hexahedral elements
[NodesOnElement,Coordinates,RegionOnElement,numnp,numel,nen] = Tet10toHex8(NodesOnElement,Coordinates,...
           RegionOnElement,FacetsOnElement,FacetsOnElementInt,ElementsOnFacet,...
           numEonB,numnp,numel,nen,numfac);

% Boundary conditions
nodexm = find(abs(Coordinates(:,1)-0)<1e-9); %rollers at x=0
nodexp = find(abs(Coordinates(:,1)-2)<1e-9); %prescribed u_x at x=2
nodeym = find(abs(Coordinates(:,2)-0)<1e-9); %rollers at y=0
nodezm = find(abs(Coordinates(:,3)-0)<1e-9); %rollers at z=0
NodeBC = [nodexm 1*ones(length(nodexm),1) zeros(length(nodexm),1)
          nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodeym 2*ones(length(nodeym),1) zeros(length(nodeym),1)
          nodezm 3*ones(length(nodezm),1) zeros(length(nodezm),1)];
numBC = length(NodeBC);

ProbType = [numnp numel nummat 3 3 nen];

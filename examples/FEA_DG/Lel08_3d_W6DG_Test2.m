% Test for wedge element with cohesive elements.
% Domain: Four wedge elements, CZ between all faces
% Loading: Nodal displacements on top face.
%
% Last revision: 10/28/2017 TJT

clear
% clc

Coordinates = [0 0 0
             2 0 0
             0 1 0
             0 0 3
             2 0 3
             0 1 3
             2 1 0
             2 1 3
             0 0 6
             2 0 6
             0 1 6
             2 1 6];
% NodesOnElement = [1 2 3 4 5 6];
% NodesOnElement = [3 1 2 6 4 5];
NodesOnElement = [2 3 1 5 6 4
                  2 7 3 5 8 6
                  5 6 4 10 11 9
                  5 8 6 10 12 11];
RegionOnElement = [1; 2; 1; 2];
numel = 4;
numnp = 12;
nen = 6;
NodeBC = [1 1 0
          1 2 0
          [(1:3)'; 7] 3*ones(4,1) zeros(4,1)
          2 2 0
          9 3 0.09*2
          10 3 0.09*2
          11 3 0.09*2
          12 3 0.09*2];
numBC = length(NodeBC);

MatTypeTable = [1 2; 1 1];

young = 100;
pois = .25;
thick = 1;
MateT = [young pois thick
         young pois thick];
nummat = 2;

% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 0;
SEHist = 0;

% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
InterTypes = [1 0
              1 1]; % only put CZM between the element edges between materials 1-2
ndm = 3;
[NodesOnElement,RegionOnElement,Coordinates,numnp,Output_data] ...
    = DEIPFunction(InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm);


% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateNodeSetFunction(0,RegionOnElement,Output_data,NodeBCCG,numBCCG);

% Insert CZ couplers
% CZ element stiffness
CZprop = [50 3 0.2];

[NodesOnElement,RegionOnElement,Coordinates,numnp,nen,numel,nummat,RegionsOnInterface,MateT,MatTypeTable...
] = InterFunction(1,InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,Output_data,7,CZprop,MateT,MatTypeTable);

ProbType = [numnp numel nummat 3 3 nen]; %[8 3 3 1];

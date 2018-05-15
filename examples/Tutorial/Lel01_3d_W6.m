% Test for wedge element.
% Domain: One wedge element
% Loading: Nodal forces on top face.
%
% Last revision: 12/04/2015 TJT

clear
% clc

Coordinates = [0 0 0
             2 0 0
             0 1 0
             0 0 3
             2 0 3
             0 1 3
             2 1 0
             2 1 3];
% NodesOnElement = [1 2 3 4 5 6];
% NodesOnElement = [3 1 2 6 4 5];
NodesOnElement = [2 3 1 5 6 4
                  2 7 3 5 8 6];
RegionOnElement = [1; 1];
numel = 2;
numnp = 8;
nen = 6;
NodeBC = [1 1 0
          1 2 0
          [(1:3)'; 7] 3*ones(4,1) zeros(4,1)
          2 2 0];
numBC = length(NodeBC);
numNodalF = 4;
NodeLoad = [4 3 1
            5 3 2
            6 3 2
            8 3 1];

MatTypeTable = [1; 1];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 0;
SEHist = 0;

young = 100;
pois = .25;
thick = 1;
MateT = [young pois thick];
nummat = 1;
ProbType = [numnp numel nummat 3 3 nen]; %[8 3 3 1];

% Test for pyramid element.
% Domain: 6 pyramid elements
% Loading: Nodal forces on top face.
%
% Last revision: 05/08/2018 TJT

clear
% clc

% % uniform coordinates
% Coordinates = [0 0 0
%                2 0 0
%                2 2 0
%                0 2 0
%                0 0 2
%                2 0 2
%                2 2 2
%                0 2 2
%                1 1 1];
% unequal coordinates
Coordinates = [0 0 0
               2 0 0
               2 1 0
               0 1 0
               0 0 3
               2 0 3
               2 1 3
               0 1 3
               1.1 .4 1.6]; % perturbed center node
%                1 .5 1.5];
NodesOnElement = [1 2 3 4 9
                  1 5 6 2 9
                  2 6 7 3 9
                  3 7 8 4 9
                  4 8 5 1 9
                  5 8 7 6 9];
RegionOnElement = ones(6,1);
numel = 6;
numnp = 9;
nen = 5;
NodeBC = [1 3 0
          2 3 0
          3 3 0
          4 3 0
          1 2 0
          2 2 0
          5 2 0
          6 2 0
          1 1 0
          4 1 0
          5 1 0
          8 1 0];
numBC = length(NodeBC);
numNodalF = 4;
NodeLoad = [5 3 2
            6 3 2
            7 3 2
            8 3 2];

MatTypeTable = [1; 1];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 0;
SEHist = 1;

young = 100;
pois = .25;
thick = 1;
MateT = [young pois thick];
nummat = 1;
ProbType = [numnp numel nummat 3 3 nen];

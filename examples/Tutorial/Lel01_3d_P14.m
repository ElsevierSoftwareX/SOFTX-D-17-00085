% Test for quadratic pyramid element.
% Domain: 1 pyramid element
% Loading: Nodal displacement on exposed face
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
%                1 0 0
%                2 1 0
%                1 2 0
%                0 1 0
%                0 0 1
%                1 0 1
%                1 1 1
%                0 1 1
%                1 1 0];
% perturbed mid side nodes
Coordinates = [0 0 0
               2 0 0
               2 2 0
               0 2 0
               0 0 2
               1.1 0 0
               2 .9 0
               1.05 2 0
               0 .85 0
               0 0 1.1
               1 0 1
               1 1 1
               0 1 1
               1.1 .9 0];
NodesOnElement = (1:14);
RegionOnElement = 1;
numel = 1;
numnp = 14;
nen = 14;
NodeBC = [1 3 0
          2 3 0
          3 3 0
          4 3 0
          6 3 0
          7 3 0
          8 3 0
          9 3 0
          14 3 0
          1 2 0
          2 2 0
          5 2 0
          6 2 0
          10 2 0
          11 2 0
          1 1 0
          4 1 0
          5 1 0
          9 1 0
          10 1 0
          13 1 0
          5 3 .2
          11 3 .1*Coordinates(11,3)
          12 3 .1*Coordinates(12,3)
          13 3 .1*Coordinates(13,3)];
numBC = length(NodeBC);
numNodalF = 0;

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

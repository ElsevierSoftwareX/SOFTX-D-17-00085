% Simple 2 element test problem. Demonstrates the minimum data required for
% FEA_Program.
% Domain: 40x20 rectangle, two linear triangles
% Loading: Pressure on top edge.
%
% Last revision: 12/09/2015 TJT

clear
% clc

%% Required Model Inputs

% Mesh Nodal Coordinates
Coordinates = [0 0
             40 0
             0 20
             40 20];

% Mesh Element Connectivities
NodesOnElement = [1 4 3 0
      1 2 4 0];
RegionOnElement = [1 1]';

% Mesh Material Properties
MateT = [1e6 0.25 1];
MatTypeTable = [1; 1];

% Problem Size Parameters
ProbType = [length(Coordinates) size(NodesOnElement,1) size(MateT,1) ...
            2 2 size(NodesOnElement,2)];

%% Optional Model Inputs

% Mesh Boundary Conditions and Loads
NodeBC = [1 2 0
          2 1 0
          2 2 0];
numBC = 3;
NodeLoad = [3 2 -4
            4 2 -4];
% numNodalF = 2;
numNodalF = 0;
SurfacesL = [ 3 4 1 2    0     -0.2     0];
numSL = 1;
% numSL = 0;

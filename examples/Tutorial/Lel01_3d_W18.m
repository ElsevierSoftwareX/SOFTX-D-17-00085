% Test for quadratic wedge element.
% Domain: One wedge element
% Loading: Nodal forces on top face.
%
% Last revision: 03/08/2017 TJT

clear
% clc

xl = [1 0 0 0
      2 2 0 0
      4 0 1 0
      3 2 1 0
      5 0 0 3
      6 2 0 3
      8 0 1 3
      7 2 1 3];
[Coordinates,~,~,numnp,~] = block3d('cart',2,2,2,1,1,1,12,xl,27);
Coordinates = Coordinates';
NodesOnElement = [1 3 7 19 21 25 2 5 4 20 23 22 10 12 16 11 14 13
                  3 9 7 21 27 25 6 8 5 24 26 23 12 18 16 15 17 14];
%                   7 3 9 25 21 27 5 6 8 23 24 26 16 12 18 14 15 17
RegionOnElement = [1; 1];
numel = 2;
nen = 18;
nodexm = find(abs(Coordinates(:,1)-0)<1e-9); %rollers at x=0
nodexp = find(abs(Coordinates(:,1)-2)<1e-9); %prescribed u_x at x=2
nodezp = find(abs(Coordinates(:,3)-3)<1e-9); %prescribed u_y at y=2
nodeym = find(abs(Coordinates(:,2)-0)<1e-9); %rollers at y=0
nodezm = find(abs(Coordinates(:,3)-0)<1e-9); %rollers at z=0
NodeBC = [nodexm 1*ones(length(nodexm),1) zeros(length(nodexm),1)
%           nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodeym 2*ones(length(nodeym),1) zeros(length(nodeym),1)
          nodezp 3*ones(length(nodezp),1) .1*ones(length(nodezp),1)
          nodezm 3*ones(length(nodezm),1) zeros(length(nodezm),1)];
numBC = length(NodeBC);

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

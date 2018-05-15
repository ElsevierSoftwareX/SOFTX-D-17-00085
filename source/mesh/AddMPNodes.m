function [Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen] = AddMPNodes(MPCList,pencoeff,CornerXYZ,Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen)
%
% Tim Truster
% 02/11/2017
%
% Insert the Lagrange Multiplier nodes into a mesh for periodic BC modeling
%
% PBCmat = material type ID for PBC elements
% MPCList = list of P BC, which is expressed in the order that Abaqus
% usually gives:
% [u_-,1, -1.0, u_+,1, 1.0, u_master_+,1, 1.0, u_master_-,1, -1.0]
% [u_-,2, -1.0, u_+,2, 1.0, u_master_+,2, 1.0, u_master_-,2, -1.0] 
% [u_-,3, -1.0, u_+,3, 1.0, u_master_+,3, 1.0, u_master_-,3, -1.0]
% Simplified and reordered to: 
% [u_+, u_-, u_master_+, u_master_-]

Penmat = nummat + 1;
PBCmat = nummat + 2;
ndm = size(Coordinates,2);
numMPC = size(MPCList,1);

% expand materials
nummat = nummat + 2;
MatTypeTable = [MatTypeTable [nummat-1; 25; zeros(size(MatTypeTable,1)-2,1)] [nummat; 24; zeros(size(MatTypeTable,1)-2,1)]];
MateT = [MateT; [pencoeff zeros(1,size(MateT,2)-1)]; zeros(1,size(MateT,2))];

% expand elements
nenPBC = 3+ndm;
if nen < nenPBC
    NodesOnElement = [NodesOnElement zeros(numel,nenPBC-nen)];
    nen = nenPBC;
end
RegionOnElement = [RegionOnElement; Penmat*ones(ndm,1); PBCmat*ones(numMPC,1)];
MPCnodes = (numnp+1+ndm*2:numnp+numMPC+ndm*2)';
Corners = numnp+1:numnp+ndm;
Corners2 = numnp+1+ndm:numnp+ndm*2;
NodesOnElement = [NodesOnElement; [Corners' Corners2' zeros(ndm,nen-2)]];
NodesOnElement = [NodesOnElement; [MPCList(:,1:2) ones(numMPC,1)*Corners MPCnodes zeros(numMPC,nen-nenPBC)]];
numel = numel + numMPC + ndm;

% expand nodes
numnp = numnp + numMPC + 2*ndm;
Coordinates = [Coordinates; CornerXYZ; CornerXYZ; zeros(numMPC,ndm)];


function [Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen] = AddLMNodes(PBCList,Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen)
%
% Tim Truster
% 02/11/2017
%
% Insert the Lagrange Multiplier nodes into a mesh for periodic BC modeling
%
% PBCmat = material type ID for PBC elements
% PBCList = list of P BC, which is expressed in the order that Abaqus
% usually gives:
% [u_-,1, -1.0, u_+,1, 1.0, u_master_+,1, 1.0, u_master_-,1, -1.0]
% [u_-,2, -1.0, u_+,2, 1.0, u_master_+,2, 1.0, u_master_-,2, -1.0] 
% [u_-,3, -1.0, u_+,3, 1.0, u_master_+,3, 1.0, u_master_-,3, -1.0]
% Simplified and reordered to: 
% [u_+, u_-, u_master_+, u_master_-]

PBCmat = nummat + 1;
ndm = size(Coordinates,2);
numPBC = size(PBCList,1);

% expand materials
nummat = nummat + 1;
MatTypeTable = [MatTypeTable [nummat; 23; zeros(size(MatTypeTable,1)-2,1)]];
MateT = [MateT; zeros(1,size(MateT,2))];

% expand elements
nenPBC = 5;
if nen < nenPBC
    NodesOnElement = [NodesOnElement zeros(numel,nenPBC-nen)];
    nen = nenPBC;
end
RegionOnElement = [RegionOnElement; PBCmat*ones(numPBC,1)];
PBCnodes = (numnp+1:numnp+numPBC)';
NodesOnElement = [NodesOnElement; [PBCList PBCnodes zeros(numPBC,nen-nenPBC)]];
numel = numel + numPBC;

% expand nodes
numnp = numnp + numPBC;
Coordinates = [Coordinates; zeros(numPBC,ndm)];


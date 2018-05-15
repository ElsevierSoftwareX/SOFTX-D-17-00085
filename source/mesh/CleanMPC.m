function [MPCListNew,numMPCNew,CouplerNodes] = CleanMPC(MPCListNew,numMPCnew,CouplerNodes,ndm)
%
% Tim Truster
% 03/25/2017
%
% Clean up MPC pairs

% Swap in the added middle nodes from CZ couplers
inds = CouplerNodes>0;
MPCListNew(inds,1) = CouplerNodes(inds);
inds = (CouplerNodes'<0)&(-CouplerNodes'~=MPCListNew(:,2));
% because new nodes may be higher, then switch the direction
MPCListNew(inds,1:2+ndm) = [-CouplerNodes(inds)' MPCListNew(inds,1) -MPCListNew(inds,3:2+ndm)];

% Assumes that all MPC entries have the node pairs shorted with the higher
% node ID first.

% Remove linear dependent MPC by removing extra links that point to the
% same Left node (which has the higher ID of the 2 nodes in the pair)
[~,inds] = unique(MPCListNew(:,1));
MPCListNew = MPCListNew(inds,:);

numMPCNew = size(MPCListNew,1);

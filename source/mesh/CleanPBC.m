function [PBCListNew,numPBCNew,TieNodesNew] = CleanPBC(TieNodes,ndm,PBCListNew,numPBCnew,TieNodesNew)
%
% Tim Truster
% 03/25/2017
%
% Clean up PBC pairs

% Swap in the added middle nodes from CZ couplers
PBCListNew = PBCListNew(:,[5 2 3 4]);

for i = 1:ndm
    link = find(PBCListNew(1:numPBCnew,1)==TieNodesNew(i,1)&...
                PBCListNew(1:numPBCnew,2)==TieNodesNew(i,2));
    if link > 0
        PBCListNew(link,:) = [];
        numPBCnew = numPBCnew - 1;
    end
end

% Now shrink the list
PBCListNew = PBCListNew(1:numPBCnew,:);
PBCListNew = unique(PBCListNew,'rows');

if ~all(all(TieNodes == TieNodesNew)) % Update the master ties on each PBC pair
  for i = 1:ndm
    inds = find(PBCListNew(:,3)==TieNodes(i,1)&PBCListNew(:,4)==TieNodes(i,2));
    PBCListNew(inds,3:4) = ones(length(inds),1)*TieNodesNew(i,1:2);
  end
else % remove linear dependent PBC
    [~,inds] = unique(PBCListNew(:,1));
    PBCListNew = PBCListNew(inds,:);
end
numPBCNew = size(PBCListNew,1);

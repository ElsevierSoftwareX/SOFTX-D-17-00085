function [NodeItem,numItem] = UpdateMasterBC(TieNodes,TieNodesNew,NodeItem_in,numItem_in)
%
% Tim Truster
% 02/19/2017
%
% Update the master boundary conditions on a periodic domain
%
% TieNodes are the master node pairs of boundary conditions

NodeItem = NodeItem_in;
numItem = numItem_in;

for entry = 1:numItem_in
    
    node = NodeItem(entry,1);
    if node == TieNodes(1,1)
        NodeItem(entry,1) = TieNodesNew(1,1);
    elseif node == TieNodes(2,1)
        NodeItem(entry,1) = TieNodesNew(2,1);
    elseif node == TieNodes(1,2)
        NodeItem(entry,1) = TieNodesNew(1,2);
    else
        NodeItem(entry,1) = TieNodesNew(3,1);
    end
    
end
function [NodeItem,numItem] = UpdateNodeSet(reg,RegionOnElement,ElementsOnNodeNum,ElementsOnNode,ElementsOnNodeDup,NodeItem_in,numItem_in)
%
% Tim Truster
% 01/01/2015
%
% Convert a list of nodal entries (e.g. boundary conditions) on a CG mesh
% into a DG mesh created by CGtoDGmesh
%
% reg = LIST of region ID for which the BC should be applied to; must be a
%       sorted list or a single region or 0 to indicate all regions.

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
maxel = 12;
NodeItem = zeros(maxel*numItem_in,size(NodeItem_in,2));
numItem = 0;

for entry = 1:numItem_in
    
    node = NodeItem_in(entry,1);
    row = NodeItem_in(entry,:);
    
    % Copy BCs to other versions of the node
    for ncopy = 1:ElementsOnNodeNum(node)
        
        elem = ElementsOnNode(ncopy,node);
        regN = RegionOnElement(elem);
        
        if isOctave
            tf = reg(1) == 0 || ismember(regN,reg); % only apply the BC to node instance on an element in region reg
        else
            tf = reg(1) == 0 || ismembc(regN,reg); % only apply the BC to node instance on an element in region reg
        end
        
        if tf

            numItem = numItem + 1;
            nnode = ElementsOnNodeDup(ncopy,node);
            NodeItem(numItem,:) = row;
            NodeItem(numItem,1) = nnode;

        end
        
    end
    
end

NodeItem = NodeItem(1:numItem,:);
NodeItem = unique(NodeItem,'rows');
numItem = size(NodeItem,1);
function [ix2,NodeTable2,numnp2,numel2,nen,nen1] = Q4toT3(ix,NodeTable,numnp,numel,nen,nen1)
%
% Routine to convert Q4 to T3 mesh by putting 4 T3 in each Q4 and adding a
% center node.

if nen ~= 4
    error('only works for Q4 mesh')
end
NodeTable2 = [NodeTable; zeros(numel,2)];
numnp2 = numnp + numel;
ix2 = zeros(4*numel,4);
numel2 = numel*4;
nen = 3;
nen1 = 4;

for elem = 1:numel
    ElemFlag = ix(elem,1:4);
    mat = ix(elem,5);
    xl = NodeTable(ElemFlag,:);
    x_center = mean(xl);
    node_cent = numnp+elem;
    NodeTable2(node_cent,:) = x_center;
    ix2(4*(elem-1)+1:4*elem,:) = [ElemFlag(1) ElemFlag(2) node_cent mat
                                  ElemFlag(2) ElemFlag(3) node_cent mat
                                  ElemFlag(3) ElemFlag(4) node_cent mat
                                  ElemFlag(4) ElemFlag(1) node_cent mat];
end

end
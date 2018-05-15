function [ix2,NodeTable2,RegionOnElement2,numnp2,numel2,nen2] = Tri6toQua4(ix,NodeTable,...
           RegionOnElement,numnp,numel,nen)
%
% Routine to convert quadratic 6 node tri mesh into 4 node quad mesh by
% subdividing triangular elements into 3 quad elements, adding edge nodes
% and one central node.

useCurved = 0;
if useCurved
    nodesFace = 3;
    nodesAll = 6;
else
    nodesFace = 2;
    nodesAll = 3;
end
facenodes = [3 1 2 4];
edgenodes = [1 4 7 6
             2 5 7 4
             3 6 7 5];

if nen ~= 6
    error('only works for T6 mesh')
end
NodeTable2 = [NodeTable; zeros(numel,2)];
numnp2 = numnp + numel;
numel2 = numel*3;
RegionOnElement2 = zeros(numel2,1);
ix2 = zeros(numel2,4);
nen2 = 4;

newnode = numnp;

for elem = 1:numel
    
  ElemFlag = ix(elem,1:6);
  mat = RegionOnElement(elem);
  xl = NodeTable(ElemFlag,:);
  
  newnode = newnode + 1;
  x_center = mean(xl(1:nodesAll,:));
  NodeTable2(newnode,:) = x_center;
  ElemFlag2 = [ElemFlag newnode];
  ix2(3*elem-2:3*elem,1:4) = ElemFlag2(edgenodes);
  RegionOnElement2(3*elem-2:3*elem) = mat;
  
end

end
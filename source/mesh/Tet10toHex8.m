function [ix2,NodeTable2,RegionOnElement2,numnp2,numel2,nen2] = Tet10toHex8(ix,NodeTable,...
           RegionOnElement,FacetsOnElement,FacetsOnElementInt,ElementsOnFacet,...
           numEonB,numnp,numel,nen,numfac)
%
% Routine to convert quadratic 10 node tet mesh into 8 node hex mesh by
% subdividing tetrahedral elements into 4 hex elements, adding face nodes
% and one central node.

useCurved = 0;
if useCurved
    nodesFace = 6;
    nodesAll = 10;
else
    nodesFace = 3;
    nodesAll = 4;
end
facenodes = [3 1 2 4];
edgenodes = [2 3 4 6 10 9
             3 1 4 7 10 8
             1 2 4 5 9 8
             1 3 2 7 6 5];

if nen ~= 10
    error('only works for T10 mesh')
end
numbnd = sum(numEonB);
NodeTable2 = [NodeTable; zeros(numfac+numel+numbnd,3)];
numnp2 = numnp + numfac + numbnd + numel;
numel2 = numel*4;
RegionOnElement2 = zeros(numel2,1);
ix2 = zeros(numel2,8);
nen2 = 8;
ElemIntDone = zeros(numel,4); % node numbers for each face

newnode = numnp;

for elem = 1:numel
    
  ElemFlag = ix(elem,1:10);
  mat = RegionOnElement(elem);
  xl = NodeTable(ElemFlag,:);
  
  for locF = 1:4
        
    if ~ElemIntDone(elem,locF) % face needs to add a node
        
        fac = FacetsOnElement(elem,locF);
        regI = FacetsOnElementInt(elem,locF);
        
        newnode = newnode + 1;
        ElemIntDone(elem,locF) = newnode;
        x_center = mean(xl(edgenodes(locF,1:nodesFace),:));
        NodeTable2(newnode,:) = x_center;
        
        if regI > 0 % face is not on the boundary
            elems = ElementsOnFacet(fac,1:2);
            facs = ElementsOnFacet(fac,3:4);
            inds = elems~=elem;
            elem2 = elems(inds);
            fac2 = facs(inds);
            ElemIntDone(elem2,fac2) = newnode;
        end
        
    end
        
  end
  
  newnode = newnode + 1;
  x_center = mean(xl(1:nodesAll,:));
  NodeTable2(newnode,:) = x_center;
  ElemFlag2 = [ElemFlag ElemIntDone(elem,facenodes) newnode];
  ix2(4*elem-3:4*elem,1:8) = [ElemFlag2([1 5 14 7 8 11 15 13])
                              ElemFlag2([2 6 14 5 9 12 15 11])
                              ElemFlag2([3 7 14 6 10 13 15 12])
                              ElemFlag2([4 8 13 10 9 11 15 12])];
  RegionOnElement2(4*elem-3:4*elem) = mat;
  
end

end
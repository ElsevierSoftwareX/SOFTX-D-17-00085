function [ix2,NodeTable2,numnp2,numel2,nen,nen1] = Q8toT6(ix,NodeTable,numnp,numel,nen,nen1)
%
% Routine to convert Q8 to T6 mesh by putting 4 T6 in each Q8 and adding a
% center node and four additional nodes.

if nen ~= 8
    error('only works for Q8 mesh')
end
newnodes = 5*numel;
NodeTable2 = [NodeTable; zeros(newnodes,2)];    % new size of coordinate matrix
numnp2 = numnp + newnodes;                      % introduce 5 new nodes to each existing element
ix2 = zeros(4*numel,7);                         % new size of connectivity matrix (extra one is material number)
numel2 = numel*4;                               % split one element into 4
nen = 6;                                        % overwrites old max no. of element nodes
nen1 = 7;                                       % just a variable representing nen+1?

for elem = 1:numel
    ElemFlag = ix(elem,1:8);                    % take out the node numbers associated with elem
    mat = ix(elem,9);                           % take out the material number associated with elem
    xl = NodeTable(ElemFlag(1:4),:);            % just need coordinates of corner nodes really because we're assuming straight lines
    coord13 = mean(xl);                         % create center node (13) as mean of four corner nodes
    coord9  = mean([xl(1,:);coord13]);            % create node 9 as mean of 1 & 13
    coord10 = mean([xl(2,:);coord13]);            % create node 10 as mean of 2 & 13
    coord11 = mean([xl(3,:);coord13]);            % create node 11 as mean of 3 & 13
    coord12 = mean([xl(4,:);coord13]);            % create node 12 as mean of 4 & 13
    n9  = numnp + 5*(elem-1)+1;                 % id for n9
    n10 = numnp + 5*(elem-1)+2;                 % id for n10
    n11 = numnp + 5*(elem-1)+3;                 % id for n11
    n12 = numnp + 5*(elem-1)+4;                 % id for n12
    n13 = numnp + 5*(elem-1)+5;                 % id for n13
    NodeTable2(n9,:) = coord9;                  % update coordinates for n9
    NodeTable2(n10,:) = coord10;                % update coordinates for n9
    NodeTable2(n11,:) = coord11;                % update coordinates for n9
    NodeTable2(n12,:) = coord12;                % update coordinates for n9
    NodeTable2(n13,:) = coord13;                % update coordinates for n9
    ix2(4*(elem-1)+1:4*elem,:) = [ElemFlag(1) ElemFlag(2) n13 ElemFlag(5) n10 n9  mat
                                  ElemFlag(2) ElemFlag(3) n13 ElemFlag(6) n11 n10 mat
                                  ElemFlag(3) ElemFlag(4) n13 ElemFlag(7) n12 n11 mat
                                  ElemFlag(4) ElemFlag(1) n13 ElemFlag(8) n9  n12 mat]; % six columns plus material
end

end
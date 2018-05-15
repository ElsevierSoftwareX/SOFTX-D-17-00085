% Side A nodes
if nelA == 4
    if locFA == 1	
        ilistA = [2 4 3 1];
    elseif locFA == 2
        ilistA = [4 1 3 2];
    elseif locFA == 3
        ilistA = [1 4 2 3];
    elseif locFA == 4
        ilistA = [1 2 3 4];
    end
    ilistA = ilistA([1 2 3]); % Grab the 3 nodes on the interface
end
if nelA == 6
    if locFA == 1
        ilistA = [2 3 1 5 6 4];
        ilistA = ilistA([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locFA == 2
        ilistA = [3 1 2 6 4 5];
        ilistA = ilistA([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locFA == 3
        ilistA = [1 2 3 4 5 6];
        ilistA = ilistA([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locFA == 4
        ilistA = [1 2 3 4 5 6];
        ilistA = ilistA([1 2 3]); % Grab the 3 nodes on the interface
    elseif locFA == 5
        ilistA = [6 5 4 3 2 1];
        ilistA = ilistA([1 2 3]); % Grab the 3 nodes on the interface
    end
end
if nelA == 5
    if locFA == 1
        ilistA = [1 5 2];
    elseif locFA == 2
        ilistA = [2 5 3];
    elseif locFA == 3
        ilistA = [3 5 4];
    elseif locFA == 4
        ilistA = [4 5 1];
    elseif locFA == 5
        ilistA = [1 2 3 4];
    end
end
if nelA == 8
    if locFA == 1	
        ilistA = [5 1 4 8 6 2 3 7];
    elseif locFA == 2
        ilistA = [2 6 7 3 1 5 8 4];
    elseif locFA == 3
        ilistA = [5 6 2 1 8 7 3 4];
    elseif locFA == 4
        ilistA = [4 3 7 8 1 2 6 5];
    elseif locFA == 5
        ilistA = [1 2 3 4 5 6 7 8];
    else % edge == 6
        ilistA = [8 7 6 5 4 3 2 1];
    end
    ilistA = ilistA([1 2 3 4]); % Grab the 4 nodes on the interface
end
if nelA == 10
    if locFA == 1	
        ilistA = [2 4 3 1 9 10 6 5 8 7];
    elseif locFA == 2
        ilistA = [4 1 3 2 8 7 10 9 5 6];
    elseif locFA == 3
        ilistA = [1 4 2 3 8 9 5 7 10 6];
    elseif locFA == 4
        ilistA = [1 2 3 4 5 6 7 8 9 10];
    end 
    ilistA = ilistA([1 2 3 5 6 7]); % Grab the 6 nodes on the interface
end
if nelA == 18
    if locFA == 1
        ilistA = [2 3 1 5 6 4 8 9 7 11 12 10 14 15 13 17 18 16];
        ilistA = ilistA([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locFA == 2
        ilistA = [3 1 2 6 4 5 9 7 8 12 10 11 15 13 14 18 16 17];
        ilistA = ilistA([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locFA == 3
        ilistA = (1:18);
        ilistA = ilistA([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locFA == 4
        ilistA = (1:18);
        ilistA = ilistA([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
    elseif locFA == 5
        ilistA = [6 5 4 3 2 1 11 10 12 8 7 9 15 14 13 17 16 18];
        ilistA = ilistA([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
    end
end
if nelA == 14
    if locFA == 1
        ilistA = [1 5 2 10 11 6];
    elseif locFA == 2
        ilistA = [2 5 3 11 12 7];
    elseif locFA == 3
        ilistA = [3 5 4 12 13 8];
    elseif locFA == 4
        ilistA = [4 5 1 13 10 9];
    elseif locFA == 5
        ilistA = [1 2 3 4 6 7 8 9 14];
    end
end
if nelA == 27
    if locFA == 1	
        ilistA = [5 1 4 8 6 2 3 7 17 12 20 16 18 10 19 14 13 9 11 15 23 24 22 21 25 26 27];
    elseif locFA == 2
        ilistA = [2 6 7 3 1 5 8 4 18 14 19 10 17 16 20 12 9 13 15 11 24 23 21 22 25 26 27];
    elseif locFA == 3
        ilistA = [5 6 2 1 8 7 3 4 13 18 9 17 15 19 11 20 16 14 10 12 25 26 23 24 22 21 27];
    elseif locFA == 4
        ilistA = [4 3 7 8 1 2 6 5 11 19 15 20 9 18 13 17 12 10 14 16 26 25 23 24 21 22 27];
    elseif locFA == 5
        ilistA = (1:27);
    else % edge == 6
        ilistA = [8 7 6 5 4 3 2 1 15 14 13 16 11 10 9 12 20 19 18 17 22 21 23 24 26 25 27];
    end
    ilistA = ilistA([1 2 3 4 9 10 11 12 21]); % Grab the 9 nodes on the interface
end
% Side B nodes
if nelB == 4
    if locFB == 1	
        ilistB = [2 4 3 1];
    elseif locFB == 2
        ilistB = [4 1 3 2];
    elseif locFB == 3
        ilistB = [1 4 2 3];
    elseif locFB == 4
        ilistB = [1 2 3 4];
    end
    ilistB = ilistB([1 2 3]); % Grab the 3 nodes on the interface
end
if nelB == 6
    if locFB == 1
        nelBDG = 4;
        ilistB = [2 3 1 5 6 4];
        ilistB = ilistB([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locFB == 2
        nelBDG = 4;
        ilistB = [3 1 2 6 4 5];
        ilistB = ilistB([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locFB == 3
        nelBDG = 4;
        ilistB = [1 2 3 4 5 6];
        ilistB = ilistB([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locFB == 4
        nelBDG = 3;
        ilistB = [1 2 3 4 5 6];
        ilistB = ilistB([1 2 3]); % Grab the 3 nodes on the interface
    elseif locFB == 5
        nelBDG = 3;
        ilistB = [6 5 4 3 2 1];
        ilistB = ilistB([1 2 3]); % Grab the 3 nodes on the interface
    end
end
if nelB == 5
    if locFB == 1
        ilistB = [1 5 2];
    elseif locFB == 2
        ilistB = [2 5 3];
    elseif locFB == 3
        ilistB = [3 5 4];
    elseif locFB == 4
        ilistB = [4 5 1];
    elseif locFB == 5
        ilistB = [1 2 3 4];
    end
end
if nelB == 8
    if locFB == 1	
        ilistB = [5 1 4 8 6 2 3 7];
    elseif locFB == 2
        ilistB = [2 6 7 3 1 5 8 4];
    elseif locFB == 3
        ilistB = [5 6 2 1 8 7 3 4];
    elseif locFB == 4
        ilistB = [4 3 7 8 1 2 6 5];
    elseif locFB == 5
        ilistB = [1 2 3 4 5 6 7 8];
    else % edge == 6
        ilistB = [8 7 6 5 4 3 2 1];
    end
    ilistB = ilistB([1 2 3 4]); % Grab the 4 nodes on the interface
end
if nelB == 10
    if locFB == 1	
        ilistB = [2 4 3 1 9 10 6 5 8 7];
    elseif locFB == 2
        ilistB = [4 1 3 2 8 7 10 9 5 6];
    elseif locFB == 3
        ilistB = [1 4 2 3 8 9 5 7 10 6];
    elseif locFB == 4
        ilistB = [1 2 3 4 5 6 7 8 9 10];
    end 
    ilistB = ilistB([1 2 3 5 6 7]); % Grab the 6 nodes on the interface
end
if nelB == 18
    if locFB == 1
        ilistB = [2 3 1 5 6 4 8 9 7 11 12 10 14 15 13 17 18 16];
        ilistB = ilistB([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locFB == 2
        ilistB = [3 1 2 6 4 5 9 7 8 12 10 11 15 13 14 18 16 17];
        ilistB = ilistB([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locFB == 3
        ilistB = (1:18);
        ilistB = ilistB([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locFB == 4
        ilistB = (1:18);
        ilistB = ilistB([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
    elseif locFB == 5
        ilistB = [6 5 4 3 2 1 11 10 12 8 7 9 15 14 13 17 16 18];
        ilistB = ilistB([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
    end
end
if nelB == 14
    if locFB == 1
        ilistB = [1 5 2 10 11 6];
    elseif locFB == 2
        ilistB = [2 5 3 11 12 7];
    elseif locFB == 3
        ilistB = [3 5 4 12 13 8];
    elseif locFB == 4
        ilistB = [4 5 1 13 10 9];
    elseif locFB == 5
        ilistB = [1 2 3 4 6 7 8 9 14];
    end
end
if nelB == 27
    if locFB == 1	
        ilistB = [5 1 4 8 6 2 3 7 17 12 20 16 18 10 19 14 13 9 11 15 23 24 22 21 25 26 27];
    elseif locFB == 2
        ilistB = [2 6 7 3 1 5 8 4 18 14 19 10 17 16 20 12 9 13 15 11 24 23 21 22 25 26 27];
    elseif locFB == 3
        ilistB = [5 6 2 1 8 7 3 4 13 18 9 17 15 19 11 20 16 14 10 12 25 26 23 24 22 21 27];
    elseif locFB == 4
        ilistB = [4 3 7 8 1 2 6 5 11 19 15 20 9 18 13 17 12 10 14 16 26 25 23 24 21 22 27];
    elseif locFB == 5
        ilistB = (1:27);
    else % edge == 6
        ilistB = [8 7 6 5 4 3 2 1 15 14 13 16 11 10 9 12 20 19 18 17 22 21 23 24 26 25 27];
    end
    ilistB = ilistB([1 2 3 4 9 10 11 12 21]); % Grab the 9 nodes on the interface
end
% compare through PBC link        
if iPBC > 0 %nodes from PBC link, to compare with A and D
    nodeg1 = PBCList(iPBC,1);
    nodeg2 = PBCList(iPBC,2);
else
    nodeg1 = PBCList(-iPBC,3);
    nodeg2 = PBCList(-iPBC,4);
end
if sideAB == +1
    nodeAg = nodeg1;
    nodeBg = nodeg2;
else
    nodeAg = nodeg2;
    nodeBg = nodeg1;
end
% find the node from the face nodes, rotate to get to first position
nodeABCDg = NodesOnElementCG(elemAg,ilistA(1:numfacnod));
if nelA > 8; nodeABCDg2 = NodesOnElementCG(elemAg,ilistA(numfacnod+1:2*numfacnod)); end
nodeEFGHg = NodesOnElementCG(elemBg,ilistB(1:numfacnod));
if nelB > 8; nodeEFGHg2 = NodesOnElementCG(elemBg,ilistB(numfacnod+1:2*numfacnod)); end
indA = find(nodeABCDg==nodeAg);
nodeABCDg = circshift(nodeABCDg,numfacnod-indA+1,2);
if nelA > 8; nodeABCDg2 = circshift(nodeABCDg2,numfacnod-indA+1,2); end
indB = find(nodeEFGHg==nodeBg);
nodeEFGHg = circshift(nodeEFGHg,numfacnod-indB+1,2);
if nelB > 8; nodeEFGHg2 = circshift(nodeEFGHg2,numfacnod-indB+1,2); end
% Make the element; one of these may need to be reverse clockwise
if sideAB == +1
    nodeEFGHg = nodeEFGHg(numfacnod:-1:1);
    nodeEFGHg = circshift(nodeEFGHg,1,2);
    if nelB > 8
        nodeEFGHg2 = nodeEFGHg2(numfacnod:-1:1);
        nodeEFGHg2 = circshift(nodeEFGHg2,numfacnod,2);
    end
    % Spin both faces around so that numbering is correct
    nodeABCDg = nodeABCDg(numfacnod:-1:1);
    nodeABCDg = circshift(nodeABCDg,1,2);
    if nelA > 8
        nodeABCDg2 = nodeABCDg2(numfacnod:-1:1);
        nodeABCDg2 = circshift(nodeABCDg2,numfacnod,2);
    end
    nodeEFGHg = nodeEFGHg(numfacnod:-1:1);
    nodeEFGHg = circshift(nodeEFGHg,1,2);
    if nelB > 8
        nodeEFGHg2 = nodeEFGHg2(numfacnod:-1:1);
        nodeEFGHg2 = circshift(nodeEFGHg2,numfacnod,2);
    end
    if numfacnod == 3 && nelB > 8 % wedge
        elemnodes = [nodeABCDg nodeEFGHg nodeABCDg2 nodeEFGHg2 -1*ones(1,6)];
    elseif numfacnod == 4 && nelB > 8 % hexahedral
        elemnodes = [nodeABCDg nodeEFGHg nodeABCDg2 nodeEFGHg2 -1*ones(1,4) NodesOnElementCG(elemAg,ilistA(9)) NodesOnElementCG(elemBg,ilistB(9)) -1*ones(1,5)];
    else
        elemnodes = [nodeABCDg nodeEFGHg ];
    end
else
    nodeABCDg = nodeABCDg(numfacnod:-1:1);
    nodeABCDg = circshift(nodeABCDg,1,2);
    if nelA > 8
        nodeABCDg2 = nodeABCDg2(numfacnod:-1:1);
        nodeABCDg2 = circshift(nodeABCDg2,numfacnod,2);
    end
    % Spin both faces around so that numbering is correct
    nodeABCDg = nodeABCDg(numfacnod:-1:1);
    nodeABCDg = circshift(nodeABCDg,1,2);
    if nelA > 8
        nodeABCDg2 = nodeABCDg2(numfacnod:-1:1);
        nodeABCDg2 = circshift(nodeABCDg2,numfacnod,2);
    end
    nodeEFGHg = nodeEFGHg(numfacnod:-1:1);
    nodeEFGHg = circshift(nodeEFGHg,1,2);
    if nelB > 8
        nodeEFGHg2 = nodeEFGHg2(numfacnod:-1:1);
        nodeEFGHg2 = circshift(nodeEFGHg2,numfacnod,2);
    end
    if numfacnod == 3 && nelB > 8 % wedge
        elemnodes = [nodeEFGHg nodeABCDg nodeEFGHg2 nodeABCDg2 -1*ones(1,6)];
    elseif numfacnod == 4 && nelB > 8 % hexahedral
        elemnodes = [nodeEFGHg nodeABCDg nodeEFGHg2 nodeABCDg2 -1*ones(1,4) NodesOnElementCG(elemBg,ilistB(9)) NodesOnElementCG(elemAg,ilistA(9)) -1*ones(1,5)];
    else
        elemnodes = [nodeEFGHg nodeABCDg ];
    end
end

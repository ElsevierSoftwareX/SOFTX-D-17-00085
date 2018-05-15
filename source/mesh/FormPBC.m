function [PBCListNew,numPBCnew,NodesOnLinkNew,NodesOnLinknumNew,TieNodesNew] = ...
         FormPBC(PBCListNew,numPBCnew,NodesOnLinkNew,NodesOnLinknumNew,TieNodesNew, ...
                 SurfacesI,ix,ixCG,NodeTable,numCL,ndm,PBCList,TieNodes, ...
                 NodesOnLink,NodesOnLinknum)
%
% Tim Truster
% 03/25/2017
%
% Create PBC pairs for facets that will NOT have CZ couplers too

if nargin ~= 15
    error('15 arguments are required')
end

nen_old = size(ix,2);
nen_oldCG = size(ixCG,2);
nen_bulk = nen_old;
TiesNotDone = 0;
for i = 1:ndm
TiesNotDone = (TiesNotDone || TieNodesNew(i,1) == 0);
end
        
numeT = 4;
numfnT = [3 3 3 3 3];
nloopT=[2 3 4 6 9 10
       1 3 4 7 8 10
       1 2 4 5 8 9
       1 2 3 5 6 7];
numeW = 5;
numfnW = [4 4 4 3 3];
nloopW=[2 3 5 6 8 11 14 15
       1 3 4 6 9 12 13 15
       1 2 4 5 7 10 13 14
       1 2 3 7 8 9 0 0
       4 5 6 10 11 12 0 0];
numeH = 6;
numfnH = [4 4 4 4 4 4];
nloopH=[1 4 5 8 12 16 17 20
       2 3 6 7 10 14 18 19
       1 2 5 6 9 13 17 18
       3 4 7 8 11 15 19 20
       1 2 3 4 9 10 11 12
       5 6 7 8 13 14 15 16];

if ndm == 2 || ndm == 3
    
for inter = 1:numCL
    
    elem1 = SurfacesI(inter,1);
    elem2 = SurfacesI(inter,2);
    fac1 = SurfacesI(inter,3);
    fac2 = SurfacesI(inter,4);
    
    nel1 = nnz(ix(elem1,1:nen_bulk));
    
    nel2 = nnz(ix(elem2,1:nen_bulk));
    
    %Extract patch nodal coordinates
    CouplerSet1 = ix(elem1,1:nel1);
    CouplerSet1CG = ixCG(elem1,1:nel1);
    
    %Reorder element nodes in order to integrate on bottom side
    if ndm == 2
        
        if nel1 == 4
            nel1DG = 2;
            if fac1 == 1
                ilist = [2 1];
            elseif fac1 == 2
                ilist = [3 2];
            elseif fac1 == 3
                ilist = [4 3];
            else %edge == 4
                ilist = [1 4];
            end
        elseif nel1 == 3
            nel1DG = 2;
            if fac1 == 1
                ilist = [2 1];
            elseif fac1 == 2
                ilist = [3 2];
            elseif fac1 == 3
                ilist = [1 3];
            end
        elseif nel1 == 9
            nel1DG = 3;
            if fac1 == 2
                ilist = [2 3 4 1 6 7 8 5 9];
            elseif fac1 == 3
                ilist = [3 4 1 2 7 8 5 6 9];
            elseif fac1 == 4
                ilist = [4 1 2 3 8 5 6 7 9];
            elseif fac1 == 1
                ilist = 1:9;
            end
            ilist = ilist([1 2 5]); % Grab the 3 nodes on the interface
        elseif nel1 == 6
            nel1DG = 3;
            if fac1 == 2
                ilist = [2 3 1 5 6 4];
            elseif fac1 == 3
                ilist = [3 1 2 6 4 5];
            elseif fac1 == 1
                ilist = 1:6;
            end
            ilist = ilist([1 2 4]); % Grab the 3 nodes on the interface
        end
        CouplerSet1 = CouplerSet1(ilist);
        CouplerSet1CG = CouplerSet1CG(ilist);
        
    elseif ndm == 3
        
        if nel1 == 4
            nel1DG = 3;
            if fac1 == 1	
                ilist = [2 4 3 1];
            elseif fac1 == 2
                ilist = [4 1 3 2];
            elseif fac1 == 3
                ilist = [1 4 2 3];
            elseif fac1 == 4
                ilist = [1 2 3 4];
            end
            ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
        end
        if nel1 == 6
            if fac1 == 1
                nel1DG = 4;
                ilist = [2 3 1 5 6 4];
                ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
            elseif fac1 == 2
                nel1DG = 4;
                ilist = [3 1 2 6 4 5];
                ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
            elseif fac1 == 3
                nel1DG = 4;
                ilist = [1 2 3 4 5 6];
                ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
            elseif fac1 == 4
                nel1DG = 3;
                ilist = [1 2 3 4 5 6];
                ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
            elseif fac1 == 5
                nel1DG = 3;
                ilist = [6 5 4 3 2 1];
                ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
            end
        end
        if nel1 == 8
            nel1DG = 4;
            if fac1 == 1	
                ilist = [5 1 4 8 6 2 3 7];
            elseif fac1 == 2
                ilist = [2 6 7 3 1 5 8 4];
            elseif fac1 == 3
                ilist = [5 6 2 1 8 7 3 4];
            elseif fac1 == 4
                ilist = [4 3 7 8 1 2 6 5];
            elseif fac1 == 5
                ilist = [1 2 3 4 5 6 7 8];
            else % edge == 6
                ilist = [8 7 6 5 4 3 2 1];
            end
            ilist = ilist([1 2 3 4]); % Grab the 4 nodes on the interface
        end
        if nel1 == 10
            nel1DG = 6;
            if fac1 == 1	
                ilist = [2 4 3 1 9 10 6 5 8 7];
            elseif fac1 == 2
                ilist = [4 1 3 2 8 7 10 9 5 6];
            elseif fac1 == 3
                ilist = [1 4 2 3 8 9 5 7 10 6];
            elseif fac1 == 4
                ilist = [1 2 3 4 5 6 7 8 9 10];
            end 
            ilist = ilist([1 2 3 5 6 7]); % Grab the 6 nodes on the interface
        end
        if nel1 == 18
            if fac1 == 1
                nel1DG = 9;
                ilist = [2 3 1 5 6 4 8 9 7 11 12 10 14 15 13 17 18 16];
                ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
            elseif fac1 == 2
                nel1DG = 9;
                ilist = [3 1 2 6 4 5 9 7 8 12 10 11 15 13 14 18 16 17];
                ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
            elseif fac1 == 3
                nel1DG = 9;
                ilist = (1:18);
                ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
            elseif fac1 == 4
                nel1DG = 6;
                ilist = (1:18);
                ilist = ilist([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
            elseif fac1 == 5
                nel1DG = 6;
                ilist = [6 5 4 3 2 1 11 10 12 8 7 9 15 14 13 17 16 18];
                ilist = ilist([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
            end
        end
        if nel1 == 27
            nel1DG = 9;
            if fac1 == 1	
                ilist = [5 1 4 8 6 2 3 7 17 12 20 16 18 10 19 14 13 9 11 15 23 24 22 21 25 26 27];
            elseif fac1 == 2
                ilist = [2 6 7 3 1 5 8 4 18 14 19 10 17 16 20 12 9 13 15 11 24 23 21 22 25 26 27];
            elseif fac1 == 3
                ilist = [5 6 2 1 8 7 3 4 13 18 9 17 15 19 11 20 16 14 10 12 25 26 23 24 22 21 27];
            elseif fac1 == 4
                ilist = [4 3 7 8 1 2 6 5 11 19 15 20 9 18 13 17 12 10 14 16 26 25 23 24 21 22 27];
            elseif fac1 == 5
                ilist = (1:27);
            else % edge == 6
                ilist = [8 7 6 5 4 3 2 1 15 14 13 16 11 10 9 12 20 19 18 17 22 21 23 24 26 25 27];
            end
            ilist = ilist([1 2 3 4 9 10 11 12 21]); % Grab the 9 nodes on the interface
        end
        CouplerSet1 = CouplerSet1(ilist);
        CouplerSet1CG = CouplerSet1CG(ilist);
        
    end
    
    %Extract patch nodal coordinates
    CouplerSet2 = ix(elem2,1:nel2);
    CouplerSet2CG = ixCG(elem2,1:nel2);
    
    %Reorder element nodes in order to integrate on bottom side
    if ndm == 2
        
        if nel2 == 4
            nel2DG = 2;
            if fac2 == 1
                ilist = [2 1];
            elseif fac2 == 2
                ilist = [3 2];
            elseif fac2 == 3
                ilist = [4 3];
            elseif fac2 == 4
                ilist = [1 4];
            end
        elseif nel2 == 3
            nel2DG = 2;
            if fac2 == 1
                ilist = [2 1];
            elseif fac2 == 2
                ilist = [3 2];
            elseif fac2 == 3
                ilist = [1 3];
            end
        elseif nel2 == 9
            nel2DG = 3;
            if fac2 == 2
                ilist = [2 3 4 1 6 7 8 5 9];
            elseif fac2 == 3
                ilist = [3 4 1 2 7 8 5 6 9];
            elseif fac2 == 4
                ilist = [4 1 2 3 8 5 6 7 9];
            elseif fac2 == 1
                ilist = 1:9;
            end
            ilist = ilist([1 2 5]); % Grab the 3 nodes on the interface
        elseif nel2 == 6
            nel2DG = 3;
            if fac2 == 2
                ilist = [2 3 1 5 6 4];
            elseif fac2 == 3
                ilist = [3 1 2 6 4 5];
            elseif fac2 == 1
                ilist = 1:6;
            end
            ilist = ilist([1 2 4]); % Grab the 3 nodes on the interface
        end
        CouplerSet2 = CouplerSet2(ilist);
        CouplerSet2CG = CouplerSet2CG(ilist);
        
    elseif ndm == 3
        
        if nel2 == 4
            nel2DG = 3;
            if fac2 == 1	
                ilist = [2 4 3 1];
            elseif fac2 == 2
                ilist = [4 1 3 2];
            elseif fac2 == 3
                ilist = [1 4 2 3];
            elseif fac2 == 4
                ilist = [1 2 3 4];
            end
            ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
        end
        if nel2 == 6
            if fac2 == 1
                nel2DG = 4;
                ilist = [2 3 1 5 6 4];
                ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
            elseif fac2 == 2
                nel2DG = 4;
                ilist = [3 1 2 6 4 5];
                ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
            elseif fac2 == 3
                nel2DG = 4;
                ilist = [1 2 3 4 5 6];
                ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
            elseif fac2 == 4
                nel2DG = 3;
                ilist = [1 2 3 4 5 6];
                ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
            elseif fac2 == 5
                nel2DG = 3;
                ilist = [6 5 4 3 2 1];
                ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
            end
        end
        if nel2 == 8
            nel2DG = 4;
            if fac2 == 1	
                ilist = [5 1 4 8 6 2 3 7];
            elseif fac2 == 2
                ilist = [2 6 7 3 1 5 8 4];
            elseif fac2 == 3
                ilist = [5 6 2 1 8 7 3 4];
            elseif fac2 == 4
                ilist = [4 3 7 8 1 2 6 5];
            elseif fac2 == 5
                ilist = [1 2 3 4 5 6 7 8];
            else % edge == 6
                ilist = [8 7 6 5 4 3 2 1];
            end
            ilist = ilist([1 2 3 4]); % Grab the 4 nodes on the interface
        end
        if nel2 == 10
            nel2DG = 6;
            if fac2 == 1	
                ilist = [2 4 3 1 9 10 6 5 8 7];
            elseif fac2 == 2
                ilist = [4 1 3 2 8 7 10 9 5 6];
            elseif fac2 == 3
                ilist = [1 4 2 3 8 9 5 7 10 6];
            elseif fac2 == 4
                ilist = [1 2 3 4 5 6 7 8 9 10];
            end 
            ilist = ilist([1 2 3 5 6 7]); % Grab the 6 nodes on the interface
        end
        if nel2 == 18
            if fac2 == 1
                nel2DG = 9;
                ilist = [2 3 1 5 6 4 8 9 7 11 12 10 14 15 13 17 18 16];
                ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
            elseif fac2 == 2
                nel2DG = 9;
                ilist = [3 1 2 6 4 5 9 7 8 12 10 11 15 13 14 18 16 17];
                ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
            elseif fac2 == 3
                nel2DG = 9;
                ilist = (1:18);
                ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
            elseif fac2 == 4
                nel2DG = 6;
                ilist = (1:18);
                ilist = ilist([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
            elseif fac2 == 5
                nel2DG = 6;
                ilist = [6 5 4 3 2 1 11 10 12 8 7 9 15 14 13 17 16 18];
                ilist = ilist([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
            end
        end
        if nel2 == 27
            nel2DG = 9;
            if fac2 == 1	
                ilist = [5 1 4 8 6 2 3 7 17 12 20 16 18 10 19 14 13 9 11 15 23 24 22 21 25 26 27];
            elseif fac2 == 2
                ilist = [2 6 7 3 1 5 8 4 18 14 19 10 17 16 20 12 9 13 15 11 24 23 21 22 25 26 27];
            elseif fac2 == 3
                ilist = [5 6 2 1 8 7 3 4 13 18 9 17 15 19 11 20 16 14 10 12 25 26 23 24 22 21 27];
            elseif fac2 == 4
                ilist = [4 3 7 8 1 2 6 5 11 19 15 20 9 18 13 17 12 10 14 16 26 25 23 24 21 22 27];
            elseif fac2 == 5
                ilist = (1:27);
            else % edge == 6
                ilist = [8 7 6 5 4 3 2 1 15 14 13 16 11 10 9 12 20 19 18 17 22 21 23 24 26 25 27];
            end
            ilist = ilist([1 2 3 4 9 10 11 12 21]); % Grab the 9 nodes on the interface
        end
        CouplerSet2 = CouplerSet2(ilist);
        CouplerSet2CG = CouplerSet2CG(ilist);
        
    end
    
    if nel1DG ~= nel2DG
        errstr = ['CZM element inter=' num2str(inter) ' is not made of compatible elements'];
        error(errstr)
    end
    
    if ndm == 2
        nodeA = CouplerSet1CG(1);
        nodeB = CouplerSet2CG(2);
        direction = 0;
        special = 0;
        for iPBC = 1:NodesOnLinknum(nodeA)
            jPBC = NodesOnLink(iPBC,nodeA);
            if jPBC > 0
                nodeC = PBCList(jPBC,1);
                nodeD = PBCList(jPBC,2);
                tie = PBCList(jPBC,3:4);
            else
                nodeC = PBCList(-jPBC,3);
                nodeD = PBCList(-jPBC,4);
                tie = PBCList(-jPBC,3:4);
                special = 1;
            end
            if nodeC == nodeA
                if nodeB == nodeD % found a link
                    direction = 1;
                    tie1 = tie;
                    break
                else
                    special = 0;
                end
            elseif nodeD == nodeA
                if nodeB == nodeC % found a link
                    direction = -1;
                    tie1 = tie;
                    break
                else
                    special = 0;
                end
            else
                special = 0;
            end
        end
        if direction == 0 % check the other pair for a PBC
        nodeA = CouplerSet1CG(2);
        nodeB = CouplerSet2CG(1);
        for iPBC = 1:NodesOnLinknum(nodeA)
            jPBC = NodesOnLink(iPBC,nodeA);
            if jPBC > 0
                nodeC = PBCList(jPBC,1);
                nodeD = PBCList(jPBC,2);
                tie = PBCList(jPBC,3:4);
            else
                nodeC = PBCList(-jPBC,3);
                nodeD = PBCList(-jPBC,4);
                tie = PBCList(-jPBC,3:4);
                special = 2;
            end
            if nodeC == nodeA
                if nodeB == nodeD % found a link
                    direction = 1;
                    tie1 = tie;
                    break
                else
                    special = 0;
                end
            elseif nodeD == nodeA
                if nodeB == nodeC % found a link
                    direction = -1;
                    tie1 = tie;
                    break
                else
                    special = 0;
                end
            else
                special = 0;
            end
        end
        % do another check to see if the second node is a master node
        elseif special == 0 && TiesNotDone
        nodeA = CouplerSet1CG(2);
        nodeB = CouplerSet2CG(1);
        for iPBC = 1:NodesOnLinknum(nodeA)
            jPBC = NodesOnLink(iPBC,nodeA);
            if jPBC < 0
                nodeC = PBCList(-jPBC,3);
                nodeD = PBCList(-jPBC,4);
                tie = PBCList(-jPBC,3:4);
                special = 2;
            end
            if special > 0 && nodeC == nodeA
                if nodeB == nodeD % found a link
%                     direction = 1;
                    tie1 = tie;
                    break
                else
                    special = 0;
                end
            elseif special > 0 && nodeD == nodeA
                if nodeB == nodeC % found a link
%                     direction = -1;
                    tie1 = tie;
                    break
                else
                    special = 0;
                end
            else
                special = 0;
            end
        end
        end
        
        nodeorder = [2 1 3];
        for i = 1:length(CouplerSet1) % Form new links
            nodeA = CouplerSet1(i);
            nodeB = CouplerSet2(nodeorder(i));
            if NodesOnLinknumNew(nodeA) == 0
                numPBCnew = numPBCnew + 1;
                if direction == 1
                    tie2 = [nodeA nodeB];
                else
                    tie2 = [nodeB nodeA];
                end
                PBCListNew(numPBCnew,1:5) = [tie2 tie1 tie2(1)];
                % Record which PBC ID refers to these nodes
                numA = NodesOnLinknumNew(nodeA) + 1;
                NodesOnLinkNew(numA,nodeA) = numPBCnew;
                NodesOnLinknumNew(nodeA) = numA;
                numB = NodesOnLinknumNew(nodeB) + 1;
                NodesOnLinkNew(numB,nodeB) = numPBCnew;
                NodesOnLinknumNew(nodeB) = numB;
            else
                old = 0;
                if direction == 1
                    tie2 = [nodeA nodeB];
                else
                    tie2 = [nodeB nodeA];
                end
                for link = 1:NodesOnLinknumNew(nodeA)
                    iPBC = NodesOnLinkNew(link,nodeA);
                    tie = PBCListNew(iPBC,1:2);
                    if tie == tie2
                        old = 1;
                        break
                    end
                end
                if ~old
                    numPBCnew = numPBCnew + 1;
                    PBCListNew(numPBCnew,1:5) = [tie2 tie1 tie2(1)];
                    % Record which PBC ID refers to these nodes
                    numA = NodesOnLinknumNew(nodeA) + 1;
                    NodesOnLinkNew(numA,nodeA) = numPBCnew;
                    NodesOnLinknumNew(nodeA) = numA;
                    numB = NodesOnLinknumNew(nodeB) + 1;
                    NodesOnLinkNew(numB,nodeB) = numPBCnew;
                    NodesOnLinknumNew(nodeB) = numB;
                end
            end
            if i == special % update master
                for j = 1:ndm
                    if TieNodes(j,1:2) == tie1
                        TieNodesNew(j,1:2) = tie2;
                    end
                end
                TiesNotDone = 0;
                for j = 1:ndm
                TiesNotDone = (TiesNotDone || TieNodesNew(j,1) == 0);
                end
            end
        end
        
    elseif ndm == 3

        direction = 0;
        special = 0;
        nelA = nnz(ixCG(elem1,1:nen_oldCG));
        if (nelA==4||nelA==10)
            numfnA = numfnT(fac1);
            nloopA = nloopT;
        elseif (nelA==6||nelA==18)
            numfnA = numfnW(fac1);
            nloopA = nloopW;
        else
            numfnA = numfnH(fac1);
            nloopA = nloopH;
        end
        nelB = nnz(ixCG(elem2,1:nen_oldCG));
        if (nelB==4||nelB==10)
            numfnB = numfnT(fac2);
            nloopB = nloopT;
        elseif (nelB==6||nelB==18)
            numfnB = numfnW(fac2);
            nloopB = nloopW;
        else
            numfnB = numfnH(fac2);
            nloopB = nloopH;
        end
        for i = 1:numfnA
            nodeA = CouplerSet1CG(i);
            for iPBC = 1:NodesOnLinknum(nodeA)
                jPBC = NodesOnLink(iPBC,nodeA);
                if jPBC > 0
                    nodeC = PBCList(jPBC,1);
                    nodeD = PBCList(jPBC,2);
                    tie = PBCList(jPBC,3:4);
                else
                    nodeC = PBCList(-jPBC,3);
                    nodeD = PBCList(-jPBC,4);
                    tie = PBCList(-jPBC,3:4);
                    special = i;
                end
                if nodeC == nodeA
                    if ismember(nodeD,CouplerSet2CG) % found a link
                        direction = 1;
                        tie1 = tie;
                        iLink = jPBC;
                        break
                    else
                        special = 0;
                    end
                elseif nodeD == nodeA
                    if ismember(nodeC,CouplerSet2CG) % found a link
                        direction = -1;
                        tie1 = tie;
                        iLink = jPBC;
                        break
                    else
                        special = 0;
                    end
                else
                    special = 0;
                end
            end
            if direction ~= 0
                break
            end
        end
        % do another check to see if the second node is a master node
        if special == 0 && TiesNotDone
        for i = 1:numfnA
            nodeA = CouplerSet1CG(i);
            for iPBC = 1:NodesOnLinknum(nodeA)
                jPBC = NodesOnLink(iPBC,nodeA);
                if jPBC > 0
                    nodeC = PBCList(jPBC,1);
                    nodeD = PBCList(jPBC,2);
                    tie = PBCList(jPBC,3:4);
                else
                    nodeC = PBCList(-jPBC,3);
                    nodeD = PBCList(-jPBC,4);
                    tie = PBCList(-jPBC,3:4);
                    special = i;
                end
                if nodeC == nodeA
                    if ismember(nodeD,CouplerSet2CG) % found a link
%                         direction = 1;
                        tie1 = tie;
%                         iLink = jPBC;
                        break
                    else
                        special = 0;
                    end
                elseif nodeD == nodeA
                    if ismember(nodeC,CouplerSet2CG) % found a link
%                         direction = -1;
                        tie1 = tie;
%                         iLink = jPBC;
                        break
                    else
                        special = 0;
                    end
                else
                    special = 0;
                end
            end
            if special ~= 0
                break
            end
        end
        end
        
        % compare through PBC link
        if iLink > 0 %nodes from PBC link, to compare with A and D
            nodeg1 = PBCList(iLink,1);
            nodeg2 = PBCList(iLink,2);
        else
            nodeg1 = PBCList(-iLink,3);
            nodeg2 = PBCList(-iLink,4);
        end
        sideAB = direction;
        if sideAB == +1
            nodeAg = nodeg1;
            nodeBg = nodeg2;
        else
            nodeAg = nodeg2;
            nodeBg = nodeg1;
        end
        
        % find the node from the face nodes, rotate to get to first position
        numfacnod = numfnA;
        nodeABCDg = CouplerSet1CG(1:numfacnod);
        node2ABCDg = CouplerSet1(1:numfacnod);
        if nelA > 8
            nodeABCDg2 = CouplerSet1CG(numfacnod+1:2*numfacnod);
            node2ABCDg2 = CouplerSet1(numfacnod+1:2*numfacnod);
        end
        nodeEFGHg = CouplerSet2CG(1:numfacnod);
        node2EFGHg = CouplerSet2(1:numfacnod);
        if nelB > 8
            nodeEFGHg2 = CouplerSet2CG(numfacnod+1:2*numfacnod);
            node2EFGHg2 = CouplerSet2(numfacnod+1:2*numfacnod);
        end
        indA = find(nodeABCDg==nodeAg);
        nodeABCDg = circshift(nodeABCDg',numfacnod-indA+1)';
        node2ABCDg = circshift(node2ABCDg',numfacnod-indA+1)';
        if nelA > 8
            nodeABCDg2 = circshift(nodeABCDg2',numfacnod-indA+1)';
            node2ABCDg2 = circshift(node2ABCDg2',numfacnod-indA+1)';
        end
        indB = find(nodeEFGHg==nodeBg);
        nodeEFGHg = circshift(nodeEFGHg',numfacnod-indB+1)';
        node2EFGHg = circshift(node2EFGHg',numfacnod-indB+1)';
        if nelB > 8
            nodeEFGHg2 = circshift(nodeEFGHg2',numfacnod-indB+1)';
            node2EFGHg2 = circshift(node2EFGHg2',numfacnod-indB+1)';
        end
        % Make the element; one of these may need to be reverse clockwise
        if sideAB == +1
            node2EFGHg = node2EFGHg(numfacnod:-1:1);
            node2EFGHg = circshift(node2EFGHg',1)';
            if nelB > 8
                node2EFGHg2 = node2EFGHg2(numfacnod:-1:1);
                node2EFGHg2 = circshift(node2EFGHg2,numfacnod,2);
            end
            % Spin both faces around so that numbering is correct
            node2ABCDg = node2ABCDg(numfacnod:-1:1);
            node2ABCDg = circshift(node2ABCDg',1)';
            if nelA > 8
                node2ABCDg2 = node2ABCDg2(numfacnod:-1:1);
                node2ABCDg2 = circshift(node2ABCDg2,numfacnod,2);
            end
            node2EFGHg = node2EFGHg(numfacnod:-1:1);
            node2EFGHg = circshift(node2EFGHg',1)';
            if nelB > 8
                node2EFGHg2 = node2EFGHg2(numfacnod:-1:1);
                node2EFGHg2 = circshift(node2EFGHg2,numfacnod,2);
            end
            if numfacnod == 3 && nelB > 8 % wedge
                elemnodes = [node2ABCDg node2ABCDg2 node2EFGHg node2EFGHg2];
            elseif numfacnod == 4 && nelB > 8 % hexahedral
                elemnodes = [node2ABCDg node2ABCDg2 CouplerSet1(9) node2EFGHg node2EFGHg2 CouplerSet2(9)];
            else
                elemnodes = [node2ABCDg node2EFGHg ];
            end
        else
            node2ABCDg = node2ABCDg(numfacnod:-1:1);
            node2ABCDg = circshift(node2ABCDg',1)';
            if nelA > 8
                node2ABCDg2 = node2ABCDg2(numfacnod:-1:1);
                node2ABCDg2 = circshift(node2ABCDg2,numfacnod,2);
            end
            % Spin both faces around so that numbering is correct
            node2ABCDg = node2ABCDg(numfacnod:-1:1);
            node2ABCDg = circshift(node2ABCDg',1)';
            if nelA > 8
                node2ABCDg2 = node2ABCDg2(numfacnod:-1:1);
                node2ABCDg2 = circshift(node2ABCDg2,numfacnod,2);
            end
            node2EFGHg = node2EFGHg(numfacnod:-1:1);
            node2EFGHg = circshift(node2EFGHg',1)';
            if nelB > 8
                node2EFGHg2 = node2EFGHg2(numfacnod:-1:1);
                node2EFGHg2 = circshift(node2EFGHg2,numfacnod,2);
            end
            if numfacnod == 3 && nelB > 8 % wedge
                elemnodes = [node2EFGHg node2EFGHg2 node2ABCDg node2ABCDg2];
            elseif numfacnod == 4 && nelB > 8 % hexahedral
                elemnodes = [node2EFGHg node2EFGHg2 node2ABCDg node2ABCDg2 CouplerSet2(9) CouplerSet1(9)];
            else
                elemnodes = [node2EFGHg node2ABCDg ];
            end
        end
        
        numCS = length(CouplerSet1);
        if special > 0
            special = 0;
            % find it again, because the numbers changed
            for i = 1:numfacnod
              nodeA = elemnodes(i);
              if nodeA < length(NodesOnLinknum)
                for iPBC = 1:NodesOnLinknum(nodeA)
                    jPBC = NodesOnLink(iPBC,nodeA);
                    if jPBC > 0
                        nodeC = PBCList(jPBC,1);
                        nodeD = PBCList(jPBC,2);
                    else
                        nodeC = PBCList(-jPBC,3);
                        nodeD = PBCList(-jPBC,4);
                        special = i;
                    end
                    if nodeC == nodeA
                        if ismember(nodeD,elemnodes(numCS:i+numCS)) % found a link
                            break
                        else
                            special = 0;
                        end
                    else
                        special = 0;
                    end
                end
              end
                if special ~= 0
                    break
                end
            end
        end
        
        for i = 1:numCS % Form new links
            nodeA = elemnodes(i+numCS);
            nodeB = elemnodes(i);
            if NodesOnLinknumNew(nodeA) == 0
                numPBCnew = numPBCnew + 1;
%                 if direction == 1
%                     tie2 = [nodeA nodeB];
%                 else
                    tie2 = [nodeB nodeA];
%                 end
                if all(tie2==[1 5]) || all(tie2==[5 1])
                    tie2;
                end
                PBCListNew(numPBCnew,1:5) = [tie2 tie1 tie2(1)];
                % Record which PBC ID refers to these nodes
                numA = NodesOnLinknumNew(nodeA) + 1;
                NodesOnLinkNew(numA,nodeA) = numPBCnew;
                NodesOnLinknumNew(nodeA) = numA;
                numB = NodesOnLinknumNew(nodeB) + 1;
                NodesOnLinkNew(numB,nodeB) = numPBCnew;
                NodesOnLinknumNew(nodeB) = numB;
            else
                old = 0;
%                 if direction == 1
%                     tie2 = [nodeA nodeB];
%                 else
                    tie2 = [nodeB nodeA];
%                 end
                for link = 1:NodesOnLinknumNew(nodeA)
                    iPBC = NodesOnLinkNew(link,nodeA);
                    tie = PBCListNew(iPBC,1:2);
                    if all(tie == tie2)
                        old = 1;
                        break
                    end
                end
                if ~old
                if all(tie2==[1 5]) || all(tie2==[5 1])
                    tie2;
                end
                    numPBCnew = numPBCnew + 1;
                    PBCListNew(numPBCnew,1:5) = [tie2 tie1 tie2(1)];
                    % Record which PBC ID refers to these nodes
                    numA = NodesOnLinknumNew(nodeA) + 1;
                    NodesOnLinkNew(numA,nodeA) = numPBCnew;
                    NodesOnLinknumNew(nodeA) = numA;
                    numB = NodesOnLinknumNew(nodeB) + 1;
                    NodesOnLinkNew(numB,nodeB) = numPBCnew;
                    NodesOnLinknumNew(nodeB) = numB;
                end
            end
            if i == special % update master
                for j = 1:ndm
                    if TieNodes(j,1:2) == tie1
                        TieNodesNew(j,1:2) = tie2;
                    end
                end
                TiesNotDone = 0;
                for j = 1:ndm
                TiesNotDone = (TiesNotDone || TieNodesNew(j,1) == 0);
                end
            end
        end
        
    end
    
end



else
    
    disp('ndm ~= 2 or 3 is not allowed')
    return
    
end

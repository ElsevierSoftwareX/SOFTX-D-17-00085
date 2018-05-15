function ilist = OrientPBCFacet(nel,locF)
% Side A nodes
if nel == 4
    if locF == 1	
        ilist = [2 4 3 1];
    elseif locF == 2
        ilist = [4 1 3 2];
    elseif locF == 3
        ilist = [1 4 2 3];
    elseif locF == 4
        ilist = [1 2 3 4];
    end
    ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
end
if nel == 6
    if locF == 1
        ilist = [2 3 1 5 6 4];
        ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locF == 2
        ilist = [3 1 2 6 4 5];
        ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locF == 3
        ilist = [1 2 3 4 5 6];
        ilist = ilist([1 2 5 4]); % Grab the 4 nodes on the interface
    elseif locF == 4
        ilist = [1 2 3 4 5 6];
        ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
    elseif locF == 5
        ilist = [6 5 4 3 2 1];
        ilist = ilist([1 2 3]); % Grab the 3 nodes on the interface
    end
end
if nel == 8
    if locF == 1	
        ilist = [5 1 4 8 6 2 3 7];
    elseif locF == 2
        ilist = [2 6 7 3 1 5 8 4];
    elseif locF == 3
        ilist = [5 6 2 1 8 7 3 4];
    elseif locF == 4
        ilist = [4 3 7 8 1 2 6 5];
    elseif locF == 5
        ilist = [1 2 3 4 5 6 7 8];
    else % edge == 6
        ilist = [8 7 6 5 4 3 2 1];
    end
    ilist = ilist([1 2 3 4]); % Grab the 4 nodes on the interface
end
if nel == 5
    if locF == 1
        ilist = [1 5 2];
    elseif locF == 2
        ilist = [2 5 3];
    elseif locF == 3
        ilist = [3 5 4];
    elseif locF == 4
        ilist = [4 5 1];
    elseif locF == 5
        ilist = [1 2 3 4];
    end
end
if nel == 10
    if locF == 1	
        ilist = [2 4 3 1 9 10 6 5 8 7];
    elseif locF == 2
        ilist = [4 1 3 2 8 7 10 9 5 6];
    elseif locF == 3
        ilist = [1 4 2 3 8 9 5 7 10 6];
    elseif locF == 4
        ilist = [1 2 3 4 5 6 7 8 9 10];
    end 
    ilist = ilist([1 2 3 5 6 7]); % Grab the 6 nodes on the interface
end
if nel == 18
    if locF == 1
        ilist = [2 3 1 5 6 4 8 9 7 11 12 10 14 15 13 17 18 16];
        ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locF == 2
        ilist = [3 1 2 6 4 5 9 7 8 12 10 11 15 13 14 18 16 17];
        ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locF == 3
        ilist = (1:18);
        ilist = ilist([1 2 5 4 7 14 10 13 16]); % Grab the 4 nodes on the interface
    elseif locF == 4
        ilist = (1:18);
        ilist = ilist([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
    elseif locF == 5
        ilist = [6 5 4 3 2 1 11 10 12 8 7 9 15 14 13 17 16 18];
        ilist = ilist([1 2 3 7 8 9]); % Grab the 3 nodes on the interface
    end
end
if nel == 14
    if locF == 1
        ilist = [1 5 2 10 11 6];
    elseif locF == 2
        ilist = [2 5 3 11 12 7];
    elseif locF == 3
        ilist = [3 5 4 12 13 8];
    elseif locF == 4
        ilist = [4 5 1 13 10 9];
    elseif locF == 5
        ilist = [1 2 3 4 6 7 8 9 14];
    end
end
if nel == 27
    if locF == 1	
        ilist = [5 1 4 8 6 2 3 7 17 12 20 16 18 10 19 14 13 9 11 15 23 24 22 21 25 26 27];
    elseif locF == 2
        ilist = [2 6 7 3 1 5 8 4 18 14 19 10 17 16 20 12 9 13 15 11 24 23 21 22 25 26 27];
    elseif locF == 3
        ilist = [5 6 2 1 8 7 3 4 13 18 9 17 15 19 11 20 16 14 10 12 25 26 23 24 22 21 27];
    elseif locF == 4
        ilist = [4 3 7 8 1 2 6 5 11 19 15 20 9 18 13 17 12 10 14 16 26 25 23 24 21 22 27];
    elseif locF == 5
        ilist = (1:27);
    else % edge == 6
        ilist = [8 7 6 5 4 3 2 1 15 14 13 16 11 10 9 12 20 19 18 17 22 21 23 24 26 25 27];
    end
    ilist = ilist([1 2 3 4 9 10 11 12 21]); % Grab the 9 nodes on the interface
end
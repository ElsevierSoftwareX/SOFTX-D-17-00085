% Tim Truster
% 08/21/2013
% Reordering nodes for surface load integration, from element orientation
% to standard orientation.

% Modified 05/29/2014: added pressure loading by allowing edge to be signed
esign = sign(edge);
edge = abs(edge);

    %Reorder element nodes in order to integrate on bottom side
    if ndm == 2
    if edge > 1
        if nel == 4
            if edge == 2
                ilist = [2 3 4 1];
            elseif edge == 3
                ilist = [3 4 1 2];
            else %edge == 4
                ilist = [4 1 2 3];
            end
        elseif nel == 3
            if edge == 2
                ilist = [2 3 1];
            else %if edge == 3
                ilist = [3 1 2];
            end
        elseif nel == 9
            if edge == 2
                ilist = [2 3 4 1 6 7 8 5 9];
            elseif edge == 3
                ilist = [3 4 1 2 7 8 5 6 9];
            else %edge == 4
                ilist = [4 1 2 3 8 5 6 7 9];
            end
        elseif nel == 6
            if edge == 2
                ilist = [2 3 1 5 6 4];
            elseif edge == 3
                ilist = [3 1 2 6 4 5];
            end
        end
        ElemFlag(1:nel) = ElemFlag(ilist);
        xl(1:ndm,1:nel) = xl(1:ndm,ilist);
    end
    elseif ndm == 3
%     if edge < 4
        if nel == 4
            if edge == 1	
                ilist = [2 4 3 1];
            elseif edge == 2
                ilist = [4 1 3 2];
            elseif edge == 3
                ilist = [1 4 2 3];
            elseif edge == 4
                ilist = [1 2 3 4];
            end
        end
        if nel == 8
            if edge == 1	
                ilist = [5 1 4 8 6 2 3 7];
            elseif edge == 2
                ilist = [2 6 7 3 1 5 8 4];
            elseif edge == 3
                ilist = [5 6 2 1 8 7 3 4];
            elseif edge == 4
                ilist = [4 3 7 8 1 2 6 5];
            elseif edge == 5
                ilist = [1 2 3 4 5 6 7 8];
            else % edge == 6
                ilist = [8 7 6 5 4 3 2 1];
            end
        end
        if nel == 10
            if edge == 1	
                ilist = [2 4 3 1 9 10 6 5 8 7];
            elseif edge == 2
                ilist = [4 1 3 2 8 7 10 9 5 6];
            elseif edge == 3
                ilist = [1 4 2 3 8 9 5 7 10 6];
            elseif edge == 4
                ilist = [1 2 3 4 5 6 7 8 9 10];
            end 
        end
        if nel == 27
            if edge == 1	
                ilist = [5 1 4 8 6 2 3 7 17 12 20 16 18 10 19 14 13 9 11 15 23 24 22 21 25 26 27];
            elseif edge == 2
                ilist = [2 6 7 3 1 5 8 4 18 14 19 10 17 16 20 12 9 13 15 11 24 23 21 22 25 26 27];
            elseif edge == 3
                ilist = [5 6 2 1 8 7 3 4 13 18 9 17 15 19 11 20 16 14 10 12 25 26 23 24 22 21 27];
            elseif edge == 4
                ilist = [4 3 7 8 1 2 6 5 11 19 15 20 9 18 13 17 12 10 14 16 26 25 23 24 21 22 27];
            elseif edge == 5
                ilist = (1:27);
            else % edge == 6
                ilist = [8 7 6 5 4 3 2 1 15 14 13 16 11 10 9 12 20 19 18 17 22 21 23 24 26 25 27];
            end
        end
        ElemFlag(1:nel) = ElemFlag(ilist);
        xl(1:ndm,1:nel) = xl(1:ndm,ilist);
%     end
    end
    
edge = esign*edge;

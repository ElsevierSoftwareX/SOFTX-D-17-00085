function [SurfacesI] = ReverseFacets(SurfacesI,ix,NodeTable,numCL,ndm)
%
% Tim Truster
% 03/30/2017
%
% Polarize the facets of a PBC-intra-region surface

if nargin ~= 5
    error('5 arguments are required')
end

nen_old = size(ix,2);
nen_bulk = nen_old;
        
Normals = zeros(3,numCL);
Ntol = 0.02;
FacNorms = zeros(numCL,1);
numNorms = 0;

if ndm == 2 || ndm == 3
    
for inter = 1:numCL
    
    elem1 = SurfacesI(inter,1);
    fac1 = SurfacesI(inter,3);
    
    nel1 = nnz(ix(elem1,1:nen_bulk));
    
    %Extract patch nodal coordinates
    CouplerSet1 = ix(elem1,1:nel1);
    
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
        if nel1 == 5
            if fac1 == 1
                nel1DG = 3;
                ilist = [1 5 2];
            elseif fac1 == 2
                nel1DG = 3;
                ilist = [2 5 3];
            elseif fac1 == 3
                nel1DG = 3;
                ilist = [3 5 4];
            elseif fac1 == 4
                nel1DG = 3;
                ilist = [4 5 1];
            elseif fac1 == 5
                nel1DG = 4;
                ilist = [1 2 3 4];
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
        if nel1 == 14
            if fac1 == 1
                nel1DG = 6;
                ilist = [1 5 2 10 11 6];
            elseif fac1 == 2
                nel1DG = 6;
                ilist = [2 5 3 11 12 7];
            elseif fac1 == 3
                nel1DG = 6;
                ilist = [3 5 4 12 13 8];
            elseif fac1 == 4
                nel1DG = 6;
                ilist = [4 5 1 13 10 9];
            elseif fac1 == 5
                nel1DG = 9;
                ilist = [1 2 3 4 6 7 8 9 14];
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
        
    end
    
    if ndm == 2
        
        vec_b = [0 0 1];
        vec_a = [NodeTable(CouplerSet1(1),:)-NodeTable(CouplerSet1(2),:) 0];
        vec_c = VecCrossProd(vec_a,vec_b);
        n = vec_c/norm(vec_c);
        
        foundN = 0;
        for i = 1:numNorms
            dotVec = n*Normals(:,i);
            if abs(dotVec-1) < Ntol
                % keep as is
                foundN = 1;
                FacNorms(inter) = i;
                break
            elseif abs(dotVec+1) < Ntol
                % keep as is
                foundN = 1;
                SurfacesI(inter,1:4) = SurfacesI(inter,[2 1 4 3]);
                FacNorms(inter) = i;
                break
            end
        end
        if ~foundN
            numNorms = numNorms + 1;
            FacNorms(numNorms) = numNorms;
            Normals(1:3,numNorms) = n;
        end
        
    elseif ndm == 3
        
        if nel1DG == 3 || nel1DG == 6
            vec_b = NodeTable(CouplerSet1(2),:) - NodeTable(CouplerSet1(1),:);
            vec_a = NodeTable(CouplerSet1(3),:) - NodeTable(CouplerSet1(1),:);
        else %4
            vec_b = NodeTable(CouplerSet1(2),:) - NodeTable(CouplerSet1(1),:);
            vec_a = NodeTable(CouplerSet1(4),:) - NodeTable(CouplerSet1(1),:);
        end
        vec_c = VecCrossProd(vec_a,vec_b);
        n = vec_c/norm(vec_c);
        
        foundN = 0;
        for i = 1:numNorms
            dotVec = n*Normals(:,i);
            if abs(dotVec-1) < Ntol
                % keep as is
                foundN = 1;
                FacNorms(inter) = i;
                break
            elseif abs(dotVec+1) < Ntol
                % keep as is
                foundN = 1;
                SurfacesI(inter,1:4) = SurfacesI(inter,[2 1 4 3]);
                FacNorms(inter) = i;
                break
            end
        end
        if ~foundN
            numNorms = numNorms + 1;
            FacNorms(numNorms) = numNorms;
            Normals(1:3,numNorms) = n;
        end
        
    end % ndm
    
end % inter



else
    
    disp('ndm ~= 2 or 3 is not allowed')
    return
    
end

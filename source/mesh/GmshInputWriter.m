% Tim Truster
% 05/08/2018
%
% Script for regenerating Gmsh mesh file, possibly with DG or CZM
% elements added.
% data from GmshInputReader.m with text lines must be provided.
%
% Output is to a file of user's choice, in GmshOut
%
% Modification to entries in Data can be performed by user before executing
% this routine, to modify the mesh that is sent to Gmsh. However, great
% care should be taken. Namely, the amounts of entries in each block of
% Data can be changed, but the topology and amount of sections or blocks of
% data should not be altered.
%
% For adding DG or CZM elements, the flag DGCZM shoud be set to some value
% (i.e. brought into existence) outside this routine, or cleared if not in
% use.
% DG arrays should be specified for:
% - original and extra nodes along duplicated surfaces, Coordinates
% - updateSolid = 1 for GmshInputWriter to update the solid element
%   connectivity (elements of dimension ndm) with NodesOnElement
% - extra DG elements, NodesOnElementCZM{numCZMtypes}
% - new element type, eltypeCZM{2,numCZMtypes}
% - new Elset for DG elements, ElsetCZM{numCZMtypes}
% - Nsetflag = 1 to write new node sets to .msh
% - Additional Nsets to be written, NewNsetholder{numNset}


% Open a default file for writing the data
% DGCZMflag = 1;
if ~exist('GmshOut','var')
GmshOut = 'Outfile.inp';
end
fid = fopen(GmshOut,'wt');

% Check for legacy input version 1.0
if ~exist('mshver','var')
    mshver = '2.0';
end

textline = 0;
Tsection = 0;
TextSectprev = 0;

%% Sections nodes
for Block = 1:numBlocks

    % print other text first
    Tsection = Tsection + 1;
    for i = TextSectprev+1:TextSections(1,Tsection)
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    end
    TextSectprev = TextSections(1,Tsection);
    
    % print some data
    if TextSections(2,Tsection) == 1 
        
        %% nodes
        if ndm == 2
            CoordinatesOut = [(1:numnp)' Coordinates zeros(numnp,1)]';
        else
            CoordinatesOut = [(1:numnp)' Coordinates]';
        end
        fprintf(fid,'%i\n',numnp);%headerData{2,Block};
        fprintf(fid,'%i %6.12f %6.12f %6.12f\n',CoordinatesOut);
        
    elseif TextSections(2,Tsection) == 2 
        
        %% elements
        numallelem = headerData{2,Block};
        temp = numallelem;
        if exist('DGCZMflag','var') && DGCZMflag
            for j = 1:size(eltypeCZM,2)
                temp = temp + size(ElsetCZM{j},1);
            end
        end
        if exist('Nsetflag','var') && Nsetflag
            for j = 1:size(NewNsetholder,1)
                temp = temp + length(NewNsetholder{j});
            end
        end
        fprintf(fid,'%i\n',temp);
        
        % Update
        if exist('updateSolid','var') && updateSolid
            if ~exist('solidelemID','var')
                error('need to define variable (solidelemID) for list of Gmsh elements to update with new NodesOnElement')
            end
            nen_bulk = size(NodesOnElement,2);
            Data{Block}(solidelemID,7:nen_bulk+6) = NodesOnElement(1:length(solidelemID),1:nen_bulk);
        else
            disp('Warning: connectivity of solid elements will not be updated with new NodesOnElement')
        end
        
        % Write elements one at a time
        for elem = 1:numallelem
            eltype = Data{Block}(elem,2);
            % Determine number of nodes per element, nel
            nel = GmshNEL(eltype);
            if strcmp(mshver,'1.0') % legacy version
                num_of_tags = 2;
            else
                num_of_tags = Data{Block}(elem,3);
            end
            etext = [repmat('%i ',1,nel+num_of_tags+3) '\n'];
            fprintf(fid,etext,Data{Block}(elem,1:nel+num_of_tags+3));
        end
        % existing number of element groups
        if strcmp(mshver,'1.0') % legacy version
            num_of_tags = 2;
            numphys = max(Data{Block}(:,3));
        else
            num_of_tags = Data{Block}(numallelem,3);
            numphys = max(Data{Block}(:,4));
        end
        newphysID = numphys;
            
        %% add extra elements created from CZM or DG
        if exist('DGCZMflag','var') && DGCZMflag
            % array of new physical groups mapped to interface types
            physCZ = [0; 0];
            for j = 1:size(eltypeCZM,2)
                eltype = eltypeCZM{1,j}; % get element type for CZM set j
                if eltype < 0 %compute the type
                    nel = nnz(NodesOnElementCZM{j}(1,:));
                    eltype = GmshEtype(nel,ndm);
                end
                physID = eltypeCZM{2,j}; % group that the interface belongs to, from RegionsOnInterface(int,1)
                newphysID = newphysID + 1; % ID of new physical group
                physCZ(:,j) = [physID; newphysID];
                % reset element ID to end of list
                Elset = ElsetCZM{j} - ElsetCZM{j}(1) + numallelem + 1;
                numElset = size(Elset,1);
                numallelem = numallelem + numElset;
                tags = [newphysID newphysID zeros(1,num_of_tags-2)];
                % print element data
                etext = [repmat('%i ',1,nel+num_of_tags+3) '\n'];
                if strcmp(mshver,'1.0') % legacy version
                    for elem = 1:numElset
                        fprintf(fid,etext,[Elset(elem) eltype tags nel NodesOnElementCZM{j}(elem,:)]);
                    end
                else
                    for elem = 1:numElset
                        fprintf(fid,etext,[Elset(elem) eltype num_of_tags tags NodesOnElementCZM{j}(elem,:)]);
                    end
                end
            end
        end
        
        %% add extra node sets
        if exist('Nsetflag','var') && Nsetflag
            % array of new physical groups
            physNset = [0; 0];
            for j = 1:size(NewNsetholder,1)
                eltype = 15;
                physID = j;
                newphysID = newphysID + 1;
                physNset(:,j) = [physID; newphysID];
                % reset element ID to end of list
                Nset = NewNsetholder{j};
                numNset = length(Nset);
                Nset = reshape(Nset,numNset,1);
                % make element ID for the points
                Elset = (numallelem+1):(numallelem+numNset);
                numallelem = numallelem + numNset;
                tags = [newphysID newphysID zeros(1,num_of_tags-2)];
                % print element data
                etext = [repmat('%i ',1,1+num_of_tags+3) '\n'];
                if strcmp(mshver,'1.0') % legacy version
                    fprintf(fid,etext,[Elset' ones(numNset,1)*[eltype tags 1] Nset]');
                else
                    fprintf(fid,etext,[Elset' ones(numNset,1)*[eltype num_of_tags tags] Nset]');
                end
                
            end
        end
        numphys = newphysID;
        
    elseif TextSections(2,Tsection) == 3 
        
        %% physicals
        % existing number of element groups
%         numphys = numphys;
        PhysData = Data{Block};
        oldphys = headerData{2,Block};
        temp = oldphys;
        if exist('DGCZMflag','var') && DGCZMflag
                temp = temp + size(eltypeCZM,2);
        end
        if exist('Nsetflag','var') && Nsetflag
                temp = temp + size(NewNsetholder,1);
        end
        fprintf(fid,'%i\n',temp);
        
        etext = '%i %i %s\n';
        for elem = 1:oldphys
            fprintf(fid,etext,PhysData{1}(elem),PhysData{2}(elem),char(PhysData{3}(elem)));
        end
        
        if exist('DGCZMflag','var') && DGCZMflag
            % output name with format ix_Ry_Cz where
            % x = physID = row in MateT = material identifier
            % y = row of InterTypes = MateT(x,1) = region on left side
            % z = column of InterTypes = MateT(x,s) = region on right side
            nummatCG = size(InterTypes,1);
            % pad names with 0's
            num0i = fix(abs(log10(abs(nummat))))+1;
            num0is = strcat('%0',num2str(num0i),'d');
            num0m = fix(abs(log10(abs(nummatCG))))+1;
            num0ms = strcat('%0',num2str(num0m),'d');
            for j = 1:size(eltypeCZM,2)
                physID = physCZ(1,j); % group that the interface belongs to, from RegionsOnInterface(int,1)
                newphysID = physCZ(2,j);
                matR = MateT(physID,1);
                matC = MateT(physID,2);
                intername = strcat('i',sprintf(num0is,physID),'_R',sprintf(num0ms,matR),'_C',sprintf(num0ms,matC));
                fprintf(fid,etext,ndm,newphysID,intername);
            end
        end
        
        %% add extra node sets
        if exist('Nsetflag','var') && Nsetflag
            % pad names with 0's
            numNset = size(NewNsetholder,1);
            num0i = fix(abs(log10(abs(numNset))))+1;
            num0is = strcat('%0',num2str(num0i),'d');
            for j = 1:numNset
                newphysID = physNset(2,j);
                intername = strcat('Nset',sprintf(num0is,j));
                fprintf(fid,etext,0,newphysID,intername);
            end
        end
        
    else
    end

end



%% extra sections
while ~isempty(TextData{textline}) && textline < 100
    
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    
end

% Close output file
clear('GmshOut')
fclose(fid);

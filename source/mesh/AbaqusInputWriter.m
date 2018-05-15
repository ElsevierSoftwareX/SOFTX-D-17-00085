% Tim Truster
% 09/13/2014
%
% Script for regenerating Abaqus input file, possibly with DG or CZM
% elements added.
% data from AbaqusInputReader.m with text lines must be provided.
%
% Output is to a file of user's choice
%
% Modification to entries in Data can be performed by user before executing
% this routine, to modify the mesh that is sent to Abaqus. However, great
% care should be taken. Namely, the amounts of entries in each block of
% Data can be changed, but the topology and amount of sections or blocks of
% data should not be altered.
%
% For adding DG or CZM elements, the flag DGCZM shoud be set to some value
% (i.e. brought into existence) outside this routine, or cleared if not in
% use.
% DG arrays should be specified for:
% - extra DG elements, ixCZM{numCZMtypes}
% - new element type, eltypeCZM{2,numCZMtypes}
% - new Section for DG elements, auto-generated
% - new Elset for DG elements, ElsetCZM{numCZMtypes}
% - possibly a new Material for DG elements, MateCZM{numCZMnewmat}
% - extra nodes along duplicated surfaces, NodesCZM
% - modified Nsets should be flagged in TextSections by changing the value
%   from "3" to "-3", which directs the program to a separate module.

% Recreate legacy arrays
NodeTable = Coordinates;
ix = [NodesOnElement RegionOnElement];
nen1 = nen + 1;
if exist('DGCZMflag','var')
ixCZM = NodesOnElementCZM;
end

% Open a default file for writing the data
% DGCZMflag = 1;
if ~exist('AbaqOut','var')
AbaqOut = 'Outfile.inp';
end
fid = fopen(AbaqOut,'wt');

textline = 0;
Tsection = 0;
Block = 0;

%% Write nodes
Tsection = Tsection + 1;
Block = Block + 1;
for i = 1:TextSections(1,Tsection)
    textline = textline + 1;
    fprintf(fid,'%s\n',TextData{textline});
end
if ndm == 2
    fprintf(fid,'%i, %6.12f, %6.12f\n',Data{Block}');
elseif ndm == 3
    fprintf(fid,'%i, %6.12f, %6.12f, %6.12f\n',Data{Block}');
end


%% Add extra nodes from DG duplication
if exist('DGCZMflag','var')
%     fprintf(fid,'Here is where the extra nodes for DG go \n');
    if ndm == 2
        fprintf(fid,'%i, %6.12f, %6.12f\n',NodesCZM');
    elseif ndm == 3
        fprintf(fid,'%i, %6.12f, %6.12f, %6.12f\n',NodesCZM');
    end
end


%% Write elements, then the extra ones
Tsection = Tsection + 1;
for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
    textline = textline + 1;
    fprintf(fid,'%s \n',TextData{textline});
end

% Determine number of nodes per element, nel
eltype = headerData{2,2};
nel = AbaqusNEL(eltype,ndm);
etext = '%i, ';
for i = 1:nel-1
    etext = [etext '%i, '];
end
etext = [etext '%i\n'];
Block = Block + 1;
fprintf(fid,etext,Data{Block}');


%% print out extra element sections too
while TextSections(2,Tsection+1) == 2
Tsection = Tsection + 1;
for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
    textline = textline + 1;
    fprintf(fid,'%s\n',TextData{textline});
end

% Determine number of nodes per element, nel
eltype = headerData{2,2};
nel = AbaqusNEL(eltype,ndm);
etext = '%i, ';
for i = 1:nel-1
    etext = [etext '%i, '];
end
etext = [etext '%i\n'];
Block = Block + 1;
fprintf(fid,etext,Data{Block}');
end


%% add extra elements created from CZM or DG
if exist('DGCZMflag','var')
%     fprintf(fid,'Here is where the *Element for DG go \n');
    for j = 1:size(eltypeCZM,2)
        eltype = eltypeCZM{1,j}; % get element type for CZM set j
        fprintf(fid,'*Element, type=%s\n',eltype);
        nel = AbaqusNEL(eltype,ndm);
        etext = '%i, '; % set up text string for element printing
        for i = 1:nel-1
            etext = [etext '%i, '];
        end
        etext = [etext '%i\n'];
        fprintf(fid,etext,ixCZM{j}');
    end
end


%% Parts section
notdone = 1;
Sblock = 0;
while notdone
    
    % Print text lines from in-between two headers
    Tsection = Tsection + 1;
    for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    end
    
    sectype = TextSections(2,Tsection);
    sectype2 = TextSections(2,Tsection+1); % check if next header is end of part
    
    switch sectype
        
%         case 2 %*Element % Handled above
            
        case 3 %*Nset
            Block = Block + 1;
            len = length(Data{Block});
            numlines = floor(len/16); % break data into lines that are 16 entries each
            extraline = mod(len,16); % last line will be an odd number of entries
            if numlines > 0
            fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
            Data{Block}(1:numlines*16)); % print all lines with 16 entries
            end
            if extraline > 0
            etext = '';
            for i = 1:extraline-1
                etext = [etext '%i, '];
            end
            etext = [etext '%i\n'];
            fprintf(fid,etext,Data{Block}(numlines*16+1:len)'); % print out last line
            end
            
        case 4 %*Elset
            Block = Block + 1;
            len = length(Data{Block});
            numlines = floor(len/16); % break data into lines that are 16 entries each
            extraline = mod(len,16); % last line will be an odd number of entries
            if numlines > 0
            fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
            Data{Block}(1:numlines*16)); % print all lines with 16 entries
            end
            if extraline > 0
            etext = '';
            for i = 1:extraline-1
                etext = [etext '%i, '];
            end
            etext = [etext '%i\n'];
            fprintf(fid,etext,Data{Block}(numlines*16+1:len)'); % print out last line
            end
            
        case 5 %*Solid Section
            Sblock = Sblock + 1;
            % Full lines of file for section data are also stored in
            % TextData instead.
            
        case 6 %*Cohesive Section
            Sblock = Sblock + 1;
            % Full lines of file for section data are also stored in
            % TextData instead.
            
        case -3 %*Nset MODIFIED for DG addition
            if exist('DGCZMflag','var')
                fprintf(fid,'Updated node list would go here \n');
            else
            Block = Block + 1;
            len = length(Data{Block});
            numlines = floor(len/16); % break data into lines that are 16 entries each
            extraline = mod(len,16); % last line will be an odd number of entries
            if numlines > 0
            fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
            Data{Block}(1:numlines*16)); % print all lines with 16 entries
            end
            if extraline > 0
            etext = '';
            for i = 1:extraline-1
                etext = [etext '%i, '];
            end
            etext = [etext '%i\n'];
            fprintf(fid,etext,Data{Block}(numlines*16+1:len)'); % print out last line
            end
            end
            
        case 7 %*End Part
            notdone = 0;
            
    end
    
    
    %% Add an Elset and Section for DG or CZM elements
    if sectype2 == 7
            
        % Print text lines from in-between two headers
        Tsection = Tsection + 1;
        for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)-1
            textline = textline + 1;
            fprintf(fid,'%s\n',TextData{textline});
        end
        
        if exist('DGCZMflag','var')
%             fprintf(fid,'Here is where the *Elset and *Section for DG go \n');
            % Elsets first
            for j = 1:size(ElsetCZM,1)
                Elset = ElsetCZM{j};
                Elsetname = ['*Elset, elset=CZMSet-' num2str(j)];
                fprintf(fid,'%s\n',Elsetname);
                len = length(Elset);
                numlines = floor(len/16); % break data into lines that are 16 entries each
                extraline = mod(len,16); % last line will be an odd number of entries
                if numlines > 0
                fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
                Elset(1:numlines*16)); % print all lines with 16 entries
                end
                if extraline > 0
                etext = '';
                for i = 1:extraline-1
                    etext = [etext '%i, '];
                end
                etext = [etext '%i\n'];
                fprintf(fid,etext,Elset(numlines*16+1:len)'); % print out last line
                end
            end
            % Sections second
            for j = 1:size(ElsetCZM,1)
                mat = eltypeCZM{2,j};
                if isnumeric(mat) % either a new material or referenced by number
                    if mat <= size(MateData,2) % referencing an existing material from Abaqus input file
                        matname = MateData{2,mat};
                    else % add a new material
                        matname = ['CZMMaterial-' num2str(j)];
                    end
                else % use material string
                    matname = mat;
                end
%                 fprintf(fid,'*Cohesive Section, elset=CZMSet-%i, material=%s, response=TRACTION SEPARATION, thickness=SPECIFIED, stack direction=1\n',j,matname);
                % Stack direction caused a problem for 2-d elements
                fprintf(fid,'*Cohesive Section, elset=CZMSet-%i, material=%s, response=TRACTION SEPARATION, thickness=SPECIFIED\n',j,matname);
                fprintf(fid,'1., 1.\n');
            end
        end
            
            textline = textline + 1;
            fprintf(fid,'%s\n',TextData{textline});

        notdone = 0;
        
    end
    
    
end


%% Assembly section
notdone = 1;
Sblock = 0;
while notdone
    
    % Print text lines from in-between two headers
    Tsection = Tsection + 1;
    for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    end
    
    sectype = TextSections(2,Tsection);
    
    switch sectype
            
        case 3 %*Nset
            Block = Block + 1;
            len = length(Data{Block});
            numlines = floor(len/16); % break data into lines that are 16 entries each
            extraline = mod(len,16); % last line will be an odd number of entries
            if numlines > 0
            fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
            Data{Block}(1:numlines*16)); % print all lines with 16 entries
            end
            if extraline > 0
            etext = '';
            for i = 1:extraline-1
                etext = [etext '%i, '];
            end
            etext = [etext '%i\n'];
            fprintf(fid,etext,Data{Block}(numlines*16+1:len)'); % print out last line
            end
            
        case 4 %*Elset
            Block = Block + 1;
            len = length(Data{Block});
            numlines = floor(len/16); % break data into lines that are 16 entries each
            extraline = mod(len,16); % last line will be an odd number of entries
            if numlines > 0
            fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
            Data{Block}(1:numlines*16)); % print all lines with 16 entries
            end
            if extraline > 0
            etext = '';
            for i = 1:extraline-1
                etext = [etext '%i, '];
            end
            etext = [etext '%i\n'];
            fprintf(fid,etext,Data{Block}(numlines*16+1:len)'); % print out last line
            end
            
        case -3 %*Nset MODIFIED for DG addition; probably easier for the user just to change in Data block
            if exist('DGCZMflag','var')
                fprintf(fid,'Updated node list would go here \n');
            else
            Block = Block + 1;
            len = length(Data{Block});
            numlines = floor(len/16); % break data into lines that are 16 entries each
            extraline = mod(len,16); % last line will be an odd number of entries
            if numlines > 0
            fprintf(fid,'%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', ... 
            Data{Block}(1:numlines*16)); % print all lines with 16 entries
            end
            if extraline > 0
            etext = '';
            for i = 1:extraline-1
                etext = [etext '%i, '];
            end
            etext = [etext '%i\n'];
            fprintf(fid,etext,Data{Block}(numlines*16+1:len)'); % print out last line
            end
            end
            
        case 9 %*Surface
            Sblock = Sblock + 1;
            % Full lines of file for surface data are also stored in
            % TextData instead.
            
        case 8 %*End Assembly
            notdone = 0;
            
    end
    
end


%% Materials section
notdone = 1;
Mblock = 0;
BCblock = 0;
Lblock = 0;
while notdone
    
    % Print text lines from in-between two headers
    Tsection = Tsection + 1;
    for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    end
    
    sectype = TextSections(2,Tsection);
    sectype2 = TextSections(2,Tsection+1); % check if next header is end of part
    
            Mblock = Mblock + 1;
            % Full lines of file for material data are also stored in
            % TextData instead.
            
    if sectype2 ~= 10 % end of materials list
        
        % Print text lines from in-between two headers
        Tsection = Tsection + 1;
        for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)-1
            textline = textline + 1;
            fprintf(fid,'%s\n',TextData{textline});
        end
        
        if exist('DGCZMflag','var')
%             fprintf(fid,'Here is where the *Material for DG go \n');
            % ONLY add it if the material wasn't defined in Abaqus already;
            % we can point to a CZM material that was created but not used
            % in the original mesh.
            for j = 1:size(MateCZM,1)
                matname = ['CZMMaterial-' num2str(j)];
                fprintf(fid,'*Material, name=%s \n',matname);
                for i = 1:length(MateCZM{j}) % this should be a series of text lines that specify the material just as Abaqus expects
                    fprintf(fid,'%s\n',MateCZM{j}{i});
                end
            end
        end
        
            textline = textline + 1;
            fprintf(fid,'%s\n',TextData{textline});
        notdone = 0;
        
        if sectype2 == 13 % Skip next section too
            dontskipmat2 = 0;
        else
            dontskipmat2 = 1;
        end
        
    end
    
end


%% Materials section
notdone = 1;
BCblock = 0;
Lblock = 0;
while notdone && dontskipmat2 % skip the loop if no initial BCs, i.e. only materials were provided
    
    % Print text lines from in-between two headers
    Tsection = Tsection + 1;
    for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    end
    
    sectype = TextSections(2,Tsection);
    
    switch sectype
            
        case 11 %*Boundary
            BCblock = BCblock + 1;
            % Full lines of file for BC data are also stored in
            % TextData instead.
            
        case 12 %*Dsload
            Lblock = Lblock + 1;
            % Full lines of file for load data are also stored in
            % TextData instead.
            
        case 13 % end of material section
            notdone = 0;
            
    end
    
end


%% Step section
notdone = 1;
while notdone
    
    % Print text lines from in-between two headers
    Tsection = Tsection + 1;
    for i = TextSections(1,Tsection-1)+1:TextSections(1,Tsection)
        textline = textline + 1;
        fprintf(fid,'%s\n',TextData{textline});
    end
    
    sectype = TextSections(2,Tsection);
    
    switch sectype
            
        case 11 %*Boundary
            BCblock = BCblock + 1;
            % Full lines of file for BC data are also stored in
            % TextData instead.
            
        case 12 %*Dsload
            Lblock = Lblock + 1;
            % Full lines of file for load data are also stored in
            % TextData instead.
            
        case 14 %*End Step
            notdone = 0;
            
    end
    
end

% Close output file
clear('AbaqOut')
fclose(fid);
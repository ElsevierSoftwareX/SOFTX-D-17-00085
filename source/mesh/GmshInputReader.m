% Tim Truster
% 05/07/2018
%
% Generic reader for .msh file from Gmsh into DEIProgram data
% structure format.
% Text from input file is also stored for re-writing to file
%
% WARNING: generically named sets as picked from the Part, Assembly, or
% Instance windows may have the same name. I added some warning messages
% for this.
%
% Optional input: define "Gmshfile" as a string with the .msh file to open.
%
% Output arrays:
% NodeTable
% ix
% NodeBCholder
% Loadholder
% numnp, numel, nummat, nen, ndm
% MatTypeTable = [(1:nummat); ones(1,nummat)];
% MateT = zeros(nummat,1);
%
% Internal arrays:
% headerData: the text headers for sets of data from Abaqus
% Data: array of data blocks which are not sections or materials or BCs
% TextSections: record of the lines at which header sections transition;
% also records the type of header encountered, in order from top to bottom
% of file. The ID number is attributed below within the program and is used
% by AbaqusInputWriter. The line ID is the line number at which the header
% is found, MINUS any lines of numbers that are stored within Data blocks.

% Set flag for Octave
if exist('OCTAVE_VERSION', 'builtin')
    MatOct = 1;
else
    MatOct = 0;
end

% Check for legacy input version 1.0
if ~exist('mshver','var')
    mshver = '2.0';
end

if ~exist('Gmshfile','var')
[filename,pathname] = uigetfile('*.msh', 'Select Gmsh .msh file');
Gmshfile = [pathname filename];
end
fid = fopen(Gmshfile);

TextSections = zeros(2,100); % [lines to next section, section type]
TextData = cell(100,1); % sort of an initialization
Data = cell(100,1); % Each block of data will be nodes or elements
headerData = cell(2,100); % headers for what is in Data
textline = 0;
Tsection = 0;
Block = 0;

%% Big loop to read in the sets for Part
notdone = 1;
lastread = 0;
while notdone && feof(fid) == 0
    
    %line = fgetl(fid);
if MatOct && lastread
line = nline;
      lastread = 0;
else
line=fgetl(fid);
end
    
    if length(line) >= 4 && strcmp(line(1:2),'**') == 0 % not a comment line
        
        front = line(1:4);
        
        if strcmp(front,'$NOD') || strcmp(front,'$Nod')
            %% Nodal Coordinates
            
            Block = Block + 1;
            headerData{1,Block}=line; % type of set
            
            % Number of nodes
            numnp = str2double(fgetl(fid));
            headerData{2,Block}=numnp;
    
            % Read in the set
            FormatString=repmat('%f',1,4);  % Create format string based on parameter
            if MatOct
              snotdone = 1;
              width = 4;
              Stuff = zeros(width,0);
              counter = 0;
              while snotdone
                nline = fgetl(fid);
                InputText=strread(nline,'%f','delimiter',',');
                if isempty(InputText) || isnan(InputText)
                  snotdone = 0;
                  lastread = 1;
                else
                  counter = counter + 1;
                  Stuff(1:length(InputText),counter) = InputText;
                end
              end
              Stuff = Stuff';
            else
            InputText=textscan(fid,FormatString,'delimiter',','); % Read data block
            Stuff=cell2mat(InputText); % Convert to numerical array from cell
            end
            
            % Store data that was read
            Data{Block}=Stuff;
        
            textline = textline + 1;
            TextData{textline} = line;
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 1];
        
            
        elseif strcmp(front,'$ELM') || strcmp(front,'$Ele')
            %% Element connectivity
            
            Block = Block + 1;
            headerData{1,Block}=line; % type of set
            
            % Number of all element types
            numallelem = str2double(fgetl(fid));
            headerData{2,Block}=numallelem;
    
            % Read in the set
            FormatString=repmat('%f',1,6+27);  % Create format string based on parameter
            if MatOct
              snotdone = 1;
              width = 6+27;
              Stuff = zeros(width,0);
              counter = 0;
              while snotdone
                nline = fgetl(fid);
                InputText=strread(nline,'%f','delimiter',' ');
                if isempty(InputText) || isnan(InputText)
                  snotdone = 0;
                  lastread = 1;
                else
                  counter = counter + 1;
                  Stuff(1:length(InputText),counter) = InputText;
                end
              end
              Stuff = Stuff';
            else
            InputText=textscan(fid,FormatString,'delimiter',','); % Read data block
            Stuff=cell2mat(InputText); % Convert to numerical array from cell
            end
            
            % Store data that was read
            Data{Block}=Stuff;
        
            textline = textline + 1;
            TextData{textline} = line;
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 2];
        
            
        elseif strcmp(front,'$Phy')
            %% Physical Names for groups of objects
            
            Block = Block + 1;
            headerData{1,Block}=line; % type of set
            
            % Number of physical names
            numphys = str2double(fgetl(fid));
            headerData{2,Block}=numphys;
    
            % Read in the set
            FormatString=['%f' '%f' '%s'];
            if MatOct
              Stuff = cell(1,3);
              for j = 1:numphys
                nline = fgetl(fid);
                [InA,InB,InC]=strread(nline,'%f %f %s');
                Stuff{1}(j,1) = InA;
                Stuff{2}(j,1) = InB;
                Stuff{3}{j,1} = char(InC);
              end
            else
            InputText=textscan(fid,FormatString,'delimiter',','); % Read data block
            Stuff=InputText; % Convert to numerical array from cell
            end
            
            % Store data that was read
            Data{Block}=Stuff;
        
            textline = textline + 1;
            TextData{textline} = line;
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 3];
            
            
        else % store line and move on 
            
            textline = textline + 1;
            TextData{textline} = line;
            
        end
        
    else % comment line, store and move on
        textline = textline + 1;
        TextData{textline} = line;
    end
    
end

numBlocks = Block; % final number of data blocks

% delete nan
%     Stuff = Nset(~isnan(Nset));
%     Data{Block} = reshape(Stuff,4,length(Stuff)/4)';

fclose('all');

%% Process Data arrays to generate DEIProgram format

%% Get element connectivities
threeDtypes = [4 5 6 7 11 12 13 14 17 18 19];
twoDtypes = [3 4 9 10 16];
maxelem = 0;
for i = 1:numBlocks
    if TextSections(2,i) == 2
        break
        
    end
end

% Determine spatial dimension
elemList = Data{i}(:,2); % all of the different types
diff_e_type = unique(elemList);
%         sortrows
if any(ismember(diff_e_type,threeDtypes)) %some element
    ndm = 3;
    currEtypes = threeDtypes;
else
    ndm = 2;
    currEtypes = twoDtypes;
end

% Extract relevant element types and find maximum nodes on element
solidelemID = find(ismember(elemList,currEtypes)); % ID of elements relevant to DEIP
numel = length(solidelemID);
nen = 0;
for j = 1:length(diff_e_type)
    nel = GmshNEL(diff_e_type(j));
    nen = max(nen,nel);
end
if strcmp(mshver,'1.0') % legacy version
    % check columns for physical and element groups
    num_of_tags = 2;
    % get relevant elements
    NodesOnElement = Data{i}(solidelemID,3+num_of_tags+1:3+num_of_tags+nen);

    % Determine regions the elements are grouped into
    regions_temp = Data{i}(solidelemID,3); %old group ID
else
    % check columns for physical and element groups
    num_of_tags = Data{i}(solidelemID(1),3);
    % get relevant elements
    NodesOnElement = Data{i}(solidelemID,3+num_of_tags+1:3+num_of_tags+nen);

    % Determine regions the elements are grouped into
    regions_temp = Data{i}(solidelemID,4); %old group ID
end

RegToGMgroup = unique(regions_temp); %how many old ID
nummat = length(RegToGMgroup);
RegionOnElement = zeros(numel,1);
for reg = 1:nummat
    inds = regions_temp==RegToGMgroup(reg); %extract entries of that group
    RegionOnElement(inds) = reg; %assign new ID between 1 and nummat
end

% Find groups of points
pointsID = find(ismember(elemList,15)); % ID of node groups
if strcmp(mshver,'1.0') % legacy version
    Nsets_temp = Data{i}(pointsID,3); %old group ID
    num_of_tags = 2;
else
    Nsets_temp = Data{i}(pointsID,4); %old group ID
    num_of_tags = Data{i}(pointsID(1),3);
end
Nsets_temp2 = unique(Nsets_temp); %how many old ID
numNset = length(Nsets_temp2);
Nsetholder = cell(1,numNset);
for reg = 1:numNset
    inds = Nsets_temp==Nsets_temp2(reg);
    pointgroup = pointsID(inds); % ID of 'points' in the group
    Nsetholder{reg} = Data{i}(pointgroup,3+num_of_tags+1); % node ID of the points
end


%% Get nodal coordinates
for i = 1:numBlocks
    if TextSections(2,i) == 1
        Coordinates = Data{i};
        numnp = size(Coordinates,1);
        Coordinates = Coordinates(:,2:ndm+1); % strip off node ID
        break
    end
end

% Assign sections
MatTypeTable = [(1:nummat); ones(1,nummat)];
MateT = zeros(nummat,1);

clear('Gmshfile')
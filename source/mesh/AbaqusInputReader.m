% Tim Truster
% 09/11/2014
%
% Generic reader for .inp file from Abaqus into NL_FEA_Program data
% structure format.
% Text from input file is also stored for re-writing to file
%
% WARNING: generically named sets as picked from the Part, Assembly, or
% Instance windows may have the same name. I added some warning messages
% for this.
%
% Optional input: define "Abaqfile" as a string with the .inp file to open.
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

% clear
% clc

% Set flag for Octave
if exist('OCTAVE_VERSION', 'builtin')
    MatOct = 1;
else
    MatOct = 0;
end

% Set the spatial dimension of mesh
if MatOct
  if ~exist('ndm','var')
    error('ndm must be specified for Octave')
  end
else
  % Manually set ndm for now
  ndm = 2;
end
maxnumel = 1000;

% Open Abaqus .inp file
if ~exist('Abaqfile','var')
[filename,pathname] = uigetfile('*.inp', 'Select Abaqus .inp file');
Abaqfile = [pathname filename];
end
fid = fopen(Abaqfile);

TextSections = zeros(2,100); % [lines to next section, section type]
TextData = cell(100,1); % sort of an initialization
Data = cell(100,1); % Each block of data will be nodes or elements
headerData = cell(2,100); % headers for what is in Data
textline = 0;
Tsection = 0;
Block = 1;


% Search for node list
testchar = char('*Node');
line = fgetl(fid);
textline = textline + 1;
TextData{textline} = line;
while strcmp(testchar,line) == 0 && feof(fid) == 0
    line = fgetl(fid);
    textline = textline + 1;
    TextData{textline} = line;
end

headerData{1,Block}=line;
Tsection = Tsection + 1;
TextSections(:,Tsection) = [textline; 1]; 

% Read in node data
FormatString=repmat('%f',1,1+ndm);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 1+ndm;
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
% Check if ndm is correct
if Stuff(2,1)-Stuff(1,1) == 1 && Stuff(end,1) - Stuff(end-2,1) == 2 % ndm is equal to 2
    Data{Block} = Stuff;
else % reshape array to make ndm=3
    Nset=reshape(Stuff',size(Stuff,1)*size(Stuff,2),1);
    Stuff = Nset(~isnan(Nset));
    Data{Block} = reshape(Stuff,4,length(Stuff)/4)';
    ndm = 3;
end


% Get elements, first set only
if MatOct && lastread
line = nline;
      lastread = 0;
else
line=fgetl(fid);
end
textline = textline + 1;
TextData{textline} = line;
% Search for element list
testchar = char('*Elem');
while (length(line)<5 || strcmp(testchar,line(1:5)) == 0) && feof(fid) == 0
    line = fgetl(fid);
    textline = textline + 1;
    TextData{textline} = line;
end
Tsection = Tsection + 1;
TextSections(:,Tsection) = [textline; 2];
[front,back] = strtok(line, ',');
Block=Block+1;

headerData{1,Block}=front;
back = strsplit(line,'type=');
etype = strsplit(back{2},',');
headerData{2,Block}=etype;

% Determine number of nodes per element, nen
nen = AbaqusNEL(etype,ndm);

% Read in element data
FormatString=repmat('%f',1,1+nen);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 1+nen;
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
Data{Block}=Stuff; % Convert to numerical array from cell
else
InputText=textscan(fid,FormatString,'delimiter',','); % Read data block
Data{Block}=cell2mat(InputText); % Convert to numerical array from cell
end


% Set some command types
SectData = cell(2,10);
generate_check= char('generate');
Sblock = 0;


%% Big loop to read in the sets for Part
notdone = 1;
while notdone && feof(fid) == 0
    
    %line = fgetl(fid);
if MatOct && lastread
line = nline;
      lastread = 0;
else
line=fgetl(fid);
end
    
    if length(line) > 1 && strcmp(line(1:2),'**') == 0 % not a comment line
        
        [front,rem]=strtok(line,','); % get command
        lenfront = length(front);
        
        if strcmp(front,'*Nset')
            %% Example:
            % *Nset, nset=Set-10, generate
            
            Block = Block + 1;
            headerData{1,Block}=front; % type of set
            middles = strsplit(line,'nset=');
            back = strsplit(middles{2},',');
            headerData{2,Block}=back{1}; % name of set
    
            % Read in the set
            FormatString=repmat('%f',1,16);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 16;
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
            
            if ~isempty(strfind(line, generate_check)) % This data is a generation type
                Data{Block}=((Stuff(1):Stuff(3):Stuff(2)))';
        
                textline = textline + 1;
                TextData{textline} = line(1:end-10); % remove the word "generate"
            else % remove any NaN, put in a list
                nset=Stuff';
                Nset=reshape(nset,size(nset,1)*size(nset,2),1);
                Data{Block} = Nset(~isnan(Nset)&Nset>0);
        
                textline = textline + 1;
                TextData{textline} = line;
            end
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 3];
            
        elseif strcmp(front,'*Elset')
            %% Example:
            % *Elset, elset=Set-10, generate
            
            Block = Block + 1;
            headerData{1,Block}=front; % type of set
            middles = strsplit(line,'elset=');
            back = strsplit(middles{2},',');
            headerData{2,Block}=back{1}; % name of set
    
            % Read in the set
            FormatString=repmat('%f',1,16);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 16;
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
            
            if ~isempty(strfind(line, generate_check)) % This data is a generation type
                Data{Block}=((Stuff(1):Stuff(3):Stuff(2)))';
        
                textline = textline + 1;
                TextData{textline} = line(1:end-10); % remove the word "generate"
            else % remove any NaN, put in a list
                nset=Stuff';
                Nset=reshape(nset,size(nset,1)*size(nset,2),1);
                Data{Block} = Nset(~isnan(Nset)&Nset>0);
        
                textline = textline + 1;
                TextData{textline} = line;
            end
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 4];
            
        elseif strcmp(front,'*Solid Section')
            %% Example:
            % *Solid Section, elset=Set-10, material=Material-2
        
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 5];
            
            Sblock = Sblock + 1;
            middles = strsplit(line,'elset=');
            back = strsplit(middles{2},',');
            SectData{1,Sblock}=back{1}; % name of set
            middles = strsplit(line,'material=');
            back = strsplit(middles{2},',');
            SectData{2,Sblock}=back{1}; % material type
            % Any lines after this with numerical data are currently
            % ignored.
            
        elseif strcmp(front,'*Cohesive Section')
            %% Example:
            % *Cohesive Section, elset=Set-10, material=interface, response=TRACTION SEPARATION, thickness=SPECIFIED, stack direction=1
        
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 6];
            
            Sblock = Sblock + 1;
            middles = strsplit(line,'elset=');
            back = strsplit(middles{2},',');
            SectData{1,Sblock}=back{1}; % name of set
            middles = strsplit(line,'material=');
            back = strsplit(middles{2},',');
            SectData{2,Sblock}=back{1}; % material type
            % Any lines after this with numerical data are currently
            % ignored.
            
        elseif strcmp(front,'*Element')
            %% Example:
            % *Elset, elset=Set-10, generate
        
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 2];
            
            Block = Block + 1;
            headerData{1,Block}=front;
            back = strsplit(line,'type=');
            etype = strsplit(back{2},',');
            headerData{2,Block}=etype;

            % Determine number of nodes per element, nen
            nel = AbaqusNEL(etype,ndm);
            nen = max(nen,nel); % reset nen to a larger value

            % Read in element data
            FormatString=repmat('%f',1,1+nen);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 1+nen;
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
  Data{Block} = Stuff;
else
            InputText=textscan(fid,FormatString,'delimiter',','); % Read data block
            Data{Block}=cell2mat(InputText); % Convert to numerical array from cell
end
            
        elseif lenfront >= 9 && strcmp(front(1:9),'*End Part') % Exit from this loop
            
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 7];
            notdone = 0;
            
        else % store line and move on 
            
            textline = textline + 1;
            TextData{textline} = line;
            
        end
        
    else % comment line, store and move on
        textline = textline + 1;
        TextData{textline} = line;
    end
    
end

numSections = Sblock; % record number of sections found
SectData = reshape(SectData(~cellfun('isempty',SectData)),2,numSections); % remove extra cells at end


SurfData = cell(4,10); % array for surface data
generate_check= char(', generate');
Sblock = 0;

%% Big loop to read in the sets for Assembly
notdone = 1;
notskipline = 1;
while notdone && feof(fid) == 0
    
    if notskipline
    %line = fgetl(fid);
if MatOct && lastread
line = nline;
      lastread = 0;
else
line=fgetl(fid);
end
    else % skip reading the next line because it was already read by a while loop below
    notskipline = 1;
    end
    
    if strcmp(line(1:2),'**') == 0 % not a comment
        
        [front,rem]=strtok(line,','); % get command
        
        if strcmp(front,'*Nset')
            %% Example:
            % *Nset, nset=Set-5, instance=Part-2-1, generate
            
            Block = Block + 1;
            headerData{1,Block}=front; % type of set
            middles = strsplit(line,'nset=');
            back = strsplit(middles{2},',');
            headerData{2,Block}=back{1}; % name of set
    
            % Read in the set
            FormatString=repmat('%f',1,16);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 16;
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
            
            if ~isempty(strfind(line, generate_check)) % This data is a generation type
                Data{Block}=((Stuff(1):Stuff(3):Stuff(2)))';
        
                textline = textline + 1;
                TextData{textline} = line(1:end-10); % remove the word "generate"
            else % remove any NaN, put in a list
                nset=Stuff';
                Nset=reshape(nset,size(nset,1)*size(nset,2),1);
                Data{Block} = Nset(~isnan(Nset)&Nset>0);
                
                textline = textline + 1;
                TextData{textline} = line;
            end
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 3];

            % Check for duplicate set names; creating sets on parts or
            % assemblies can cause this
            for j = 3:Block-1
                settype = headerData{1,j};
                setname = headerData{2,j};
                if strcmp(settype,front) && strcmp(back{1},setname)
                    fprintf('WARNING: duplicate set name found for %s , %s; Consider renaming in .inp file.\n',settype,setname)
                end
            end
            
        elseif strcmp(front,'*Elset')
            %% Example:
            % *Elset, elset=Set-5, instance=Part-2-1
            
            Block = Block + 1;
            headerData{1,Block}=front; % type of set
            middles = strsplit(line,'elset=');
            back = strsplit(middles{2},',');
            headerData{2,Block}=back{1}; % name of set
    
            % Read in the set
            FormatString=repmat('%f',1,16);  % Create format string based on parameter
if MatOct
  snotdone = 1;
  width = 16;
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
            
            if ~isempty(strfind(line, generate_check)) % This data is a generation type
                Data{Block}=((Stuff(1):Stuff(3):Stuff(2)))';
        
                textline = textline + 1;
                TextData{textline} = line(1:end-10); % remove the word "generate"
            else % remove any NaN, put in a list
                nset=Stuff';
                Nset=reshape(nset,size(nset,1)*size(nset,2),1);
                Data{Block} = Nset(~isnan(Nset)&Nset>0);
        
                textline = textline + 1;
                TextData{textline} = line;
            end
            
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 4];

            % Check for duplicate set names; creating sets on parts or
            % assemblies can cause this
            for j = 3:Block-1
                settype = headerData{1,j};
                setname = headerData{2,j};
                if strcmp(settype,front) && strcmp(back{1},setname)
                    fprintf('WARNING: duplicate set name found for %s , %s; Consider renaming in .inp file.\n',settype,setname)
                end
            end
            
        elseif strcmp(front,'*Surface')
            %% Example:
            % *Surface, type=ELEMENT, name=Surf-2
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 9];
            
            Sblock = Sblock + 1;
            SurfData{1,Sblock}=front; % type of set
            [middle,rem]=strtok(rem,',');
            [back,rem]=strtok(rem,',');
            SurfData{2,Sblock}=back(7:end); % name of set
    
            % Read in the set of faces/sides
            SurfData{3,Sblock}=cell(2,10); % initialize a block for storing sides lists
            
            notdoneS = 1;
            numsides = 0;
            while notdoneS && feof(fid) == 0
                % Example:
                % __PickedSurf5_S5, S5
                
                line = fgetl(fid);
                if line(1) ~= '*'
                    textline = textline + 1;
                    TextData{textline} = line;
                    numsides = numsides + 1;
                    [setname,rem]=strtok(line,',');
                    SurfData{3,Sblock}{1,numsides}=setname; % name of set
                    [stype,rem]=strtok(rem,',');
                    SurfData{3,Sblock}{2,numsides}=stype; % side type
                else
                    notdoneS = 0;
                end
                
            end
            SurfData{4,Sblock} = numsides; % record how many sides there are to the surface
            notskipline = 0;
            
        elseif strcmp(front,'*End Assembly')
            
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 8];
            notdone = 0;
            
        else % store line and move on 
            
            textline = textline + 1;
            TextData{textline} = line;
            
        end
        
    else % comment line, store and move on
        textline = textline + 1;
        TextData{textline} = line;
    end
    
end

numSurfaces = Sblock; % number of surfaces found
numBlocks = Block; % final number of data blocks


MateData = cell(2,10);
Mblock = 0;
BCData = cell(4,10);
BCblock = 0;
LoadData = cell(4,10);
Lblock = 0;

%% Material loop
notdone = 1;
notskipline = 1;
while notdone && feof(fid) == 0
    
    if notskipline
    line = fgetl(fid);
    else
    notskipline = 1;
    end
    
    if strcmp(line(1:2),'**') == 0 && strcmp(line,'** ----------------------------------------------------------------') == 0 % not a comment
        
        [front,rem]=strtok(line,','); % get command
        
        if strcmp(front,'*Material')
            % Example:
            % *Material, name=Material-1
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 10];
            
            Mblock = Mblock + 1;
            MateData{1,Mblock}=front; % set name
            middles = strsplit(line,'name=');
            back = strsplit(middles{2},',');
            MateData{2,Mblock}=back{1}; % material type
        
        elseif strcmp(front,'*Boundary') %boundary conditions from initial step appear here
            % Example:
            % ** Name: BC-1 Type: Displacement/Rotation
            % *Boundary
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 11];
            
            notdoneBC = 1;
            while notdoneBC && feof(fid) == 0
                % Example:
                % Set-5, 1, 1
                
                line = fgetl(fid); % boundary conditions can have many parts
                if line(1) ~= '*'
                    textline = textline + 1;
                    TextData{textline} = line;
                    BCblock = BCblock + 1;
                    [setname,rem]=strtok(line,',');
                    BCData{1,BCblock}=setname; % name of set
                    [dof1,rem]=strtok(rem,',');
                    if strcmp(dof1,' XSYMM')
                        BCData{2,BCblock}=1;
                        BCData{3,BCblock}=1;
                        BCData{4,BCblock}=0;
                    elseif strcmp(dof1,' YSYMM')
                        BCData{2,BCblock}=2;
                        BCData{3,BCblock}=2;
                        BCData{4,BCblock}=0;
                    elseif strcmp(dof1,' ZSYMM')
                        BCData{2,BCblock}=3;
                        BCData{3,BCblock}=3;
                        BCData{4,BCblock}=0;
                    else % Set-3, 2, 2, 0.1
                        [dof2,rem]=strtok(rem,',');
                        [dispval,rem]=strtok(rem,',');
                        [dispval,rem]=strtok(dispval,',');
                        BCData{2,BCblock}=str2double(dof1);
                        BCData{3,BCblock}=str2double(dof2);
                        if ~isempty(dispval)
                        BCData{4,BCblock}=str2double(dispval);
                        else
                        BCData{4,BCblock}=0;
                        end
                    end
                else
                    notdoneBC = 0;
                end
                
            end
            notskipline = 0;
            
        elseif strcmp(front,'*Dsload')
            % Example:
            % ** Name: Load-2   Type: Pressure
            % *Dsload
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 12];
            
            notdoneL = 1;
            while notdoneL && feof(fid) == 0
                % Example:
                % Surf-2, P, -100.
                
                line = fgetl(fid);
                if line(1) ~= '*'
                    textline = textline + 1;
                    TextData{textline} = line;
                    Lblock = Lblock + 1;
                    [setname,rem]=strtok(line,',');
                    LoadData{1,Lblock}=setname; % name of set
                    [ltype,rem]=strtok(rem,',');
                    if strcmp(ltype,' P')
                        LoadData{2,Lblock}=ltype;
                        [loadval,rem]=strtok(rem,',');
                        LoadData{3,Lblock}=str2double(loadval);
                    end
                else
                    notdoneL = 0;
                end
                
            end
            notskipline = 0;
            
        else % store line and move on 
            
            textline = textline + 1;
            TextData{textline} = line;
            
        end
    
    elseif strcmp(line,'** ----------------------------------------------------------------')
            
        textline = textline + 1;
        TextData{textline} = line;
        Tsection = Tsection + 1;
        TextSections(:,Tsection) = [textline; 13];
        notdone = 0;
        
    else % comment line, store and move on
        textline = textline + 1;
        TextData{textline} = line;
    end
    
end

numMaterials = Mblock; % number of materials found
MateData = reshape(MateData(~cellfun('isempty',MateData)),2,numMaterials); % remove extra cells at end


%% Big loop to read in the sets for Step
notdone = 1;
notskipline = 1;
while notdone && feof(fid) == 0
    
    if notskipline
    line = fgetl(fid);
    else
    notskipline = 1;
    end
    
    if strcmp(line(1:2),'**') == 0 % not a comment
        
        [front,rem]=strtok(line,','); % get command
        
        if strcmp(front,'*Boundary') % boundary conditions from later steps appear here
            % Example:
            % ** Name: BC-1 Type: Displacement/Rotation
            % *Boundary
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 11];
            
            notdoneBC = 1;
            while notdoneBC && feof(fid) == 0
                % Example:
                % Set-5, 1, 1
                
                line = fgetl(fid);
                if line(1) ~= '*'
                    textline = textline + 1;
                    TextData{textline} = line;
                    BCblock = BCblock + 1;
                    [setname,rem]=strtok(line,',');
                    BCData{1,BCblock}=setname; % name of set
                    [dof1,rem]=strtok(rem,',');
                    if strcmp(dof1,' XSYMM')
                        BCData{2,BCblock}=1;
                        BCData{3,BCblock}=1;
                        BCData{4,BCblock}=0;
                    elseif strcmp(dof1,' YSYMM')
                        BCData{2,BCblock}=2;
                        BCData{3,BCblock}=2;
                        BCData{4,BCblock}=0;
                    elseif strcmp(dof1,' ZSYMM')
                        BCData{2,BCblock}=3;
                        BCData{3,BCblock}=3;
                        BCData{4,BCblock}=0;
                    else
                        [dof2,rem]=strtok(rem,',');
                        [dispval,rem]=strtok(rem,',');
                        [dispval,rem]=strtok(dispval,',');
                        BCData{2,BCblock}=str2double(dof1);
                        BCData{3,BCblock}=str2double(dof2);
                        if ~isempty(dispval)
                        BCData{4,BCblock}=str2double(dispval);
                        else
                        BCData{4,BCblock}=0;
                        end
                    end
                else
                    notdoneBC = 0;
                end
                
            end
            notskipline = 0;
            
        elseif strcmp(front,'*Dsload') % surface loadings
            % Example:
            % ** Name: Load-2   Type: Pressure
            % *Dsload
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 12];
            
            notdoneL = 1;
            while notdoneL && feof(fid) == 0
                % Example:
                % Surf-2, P, -100.
                
                line = fgetl(fid);
                if line(1) ~= '*'
                    textline = textline + 1;
                    TextData{textline} = line;
                    Lblock = Lblock + 1;
                    [setname,rem]=strtok(line,',');
                    LoadData{1,Lblock}=setname; % name of set
                    [ltype,rem]=strtok(rem,',');
                    if strcmp(ltype,' P')
                        LoadData{2,Lblock}=ltype;
                        [loadval,rem]=strtok(rem,',');
                        LoadData{3,Lblock}=str2double(loadval);
                    end
                else
                    notdoneL = 0;
                end
                
            end
            notskipline = 0;
            
        elseif strcmp(front,'*End Step') % end of step inputs
            
            textline = textline + 1;
            TextData{textline} = line;
            Tsection = Tsection + 1;
            TextSections(:,Tsection) = [textline; 14];
            notdone = 0;
            
        else % store line and move on 
            
            textline = textline + 1;
            TextData{textline} = line;
            
        end
        
    else % comment line, store and move on
        textline = textline + 1;
        TextData{textline} = line;
    end
    
end

numBCs = BCblock;
numLoads = Lblock;

fclose('all');


%% Process Data arrays to generate NL_FEA_Program format

% Get nodal coordinates
for i = 1:numBlocks
    if strcmp(headerData{1,i},'*Node')
        NodeTable = Data{i};
        numnp = size(NodeTable,1);
        NodeTable = NodeTable(:,2:ndm+1);
        break
    end
end

% Get element connectivities
ix = zeros(maxnumel,nen+1);
maxelem = 0;
for i = 1:numBlocks
    if strcmp(headerData{1,i},'*Element') % May be multiple element sets
        elemList = Data{i}(:,1);
        nel = size(Data{i},2)-1;
        maxelem = max(Data{i}(end,1),maxelem);
        ix(elemList,1:nel) = Data{i}(:,2:nel+1);
    end
end
ix = ix(1:maxelem,:);
numel = maxelem;

% Assign sections
nummat = numMaterials;
MatTypeTable = [(1:nummat); ones(1,nummat)];
MateT = zeros(nummat,1);
for section = 1:numSections
    
    setname = SectData{1,section}; % set name
    matname = SectData{2,section}; % material type
     
    for i = 1:numBlocks % find element set that needs this section assignment
        if strcmp(headerData{2,i},setname) && strcmp(headerData{1,i},'*Elset')
            elementList = Data{i};
            break
        end
    end
    
    for i = 1:numMaterials % find material number
        if strcmp(MateData{2,i},matname)
            mat = i;
            break
        end
    end
     
    % Assign material id to elements
    ix(elementList,nen+1) = mat;
    
end

% Get boundary conditions
NodeBCholder = cell(1,numBCs); % Put into a placeholder cell array, so that user can pick what they want
for bc = 1:numBCs
    
    setname = BCData{1,bc}; % set name
    dof = BCData{2,bc};
    dispval = BCData{4,bc};
     
    for i = 1:numBlocks % get list of nodes corresponding to the bc list
        if strcmp(headerData{2,i},setname) && strcmp(headerData{1,i},'*Nset')
            nodeList = Data{i};
            break
        end
    end
     
    NodeBCholder{bc} = [nodeList dof*ones(length(nodeList),1) dispval*ones(length(nodeList),1)];
     
end

% Get surface loads
Loadholder = cell(1,numLoads); % Put into a placeholder cell array, so that user can pick what they want
for forc = 1:numLoads
    
    setname = LoadData{1,forc}; % set name for surface
    ltype = LoadData{2,forc};
    lval = LoadData{3,forc};
     
    for i = 1:numSurfaces
        if strcmp(SurfData{2,i},setname)
            surfList = SurfData{3,i}; % get list of surfaces
            numsurf = SurfData{4,i}; % number of sides to the surface
            break
        end
    end
    
    SurfLoad = zeros(7,0);
    
    for i = 1:numsurf % loop over sides of surface, get element list for each one
     
        sidename = surfList{1,i}; % name for side set of elements
        for j = 1:numBlocks % get list of elements having this side of the surface
            if strcmp(headerData{2,j},sidename) && strcmp(headerData{1,j},'*Elset')
                elemList = Data{j};
                break
            end
        end
        numelsurf = length(elemList);
        
        elem = elemList(1);
        for j = 1:numBlocks % determine element type
            if strcmp(headerData{1,j},'*Element')
                iselement = find(Data{j}(:,1)==elem);
                if ~isempty(iselement)
                    eltype = headerData{2,j}; % name of element type
                    nel = AbaqusNEL(eltype,ndm); % # nodes per element
                    break
                end
            end
        end
        Stype = surfList{2,i}; % Abaqus side number
        face = AbaqusFaces(nel,Stype,ndm); % NL_FEA side number
        SurfLoad = [SurfLoad [zeros(numelsurf,2) elemList face*ones(numelsurf,1) lval*ones(numelsurf,1) zeros(numelsurf,2)]'];
    end
     
    Loadholder{forc} = SurfLoad';
     
end

% Make new version of arrays:
Coordinates = NodeTable;
clear NodeTable
NodesOnElement = ix(:,1:nen);
RegionOnElement = ix(:,nen+1);
clear ix

clear('Abaqfile')
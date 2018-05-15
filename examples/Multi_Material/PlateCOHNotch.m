% Tim Truster
% 10/28/2017
%
% Conversion file for Abaqus input for cracked plate problem
%
% NOTE: Nset Set-2, 1, and 3 were renamed in the .inp since they appeared
% several times.
%
% Now we add the interfaces, with a notch

clear
% clc
NCR = 1;

%% Read in the .inp file
ndm = 2;
Abaqfile = '../ABAQUS/PlateTest.inp';
AbaqusInputReader


%% Convert all solid elements from Q4 to T3
nen1 = nen + 1;
[NodesOnElement,Coordinates,numnp,numel,nen,nen1] = Q4toT3([NodesOnElement RegionOnElement],Coordinates,numnp,numel,nen,nen1);
RegionOnElement = NodesOnElement(:,nen1);
NodesOnElement = NodesOnElement(:,1:nen);


%% Convert solid element sections from Q4 to T3 in the .inp file
nummat = size(MateData,2);
oldtype = headerData{2,2};
headerData{2,2} = 'CPE3'; % change element type
item = TextSections(1,2); % line number where the element type is; MAY change
temptext = TextData{item,1};
temptext = char(strrep(temptext, oldtype, headerData{2,2}));
TextData{item,1} = temptext;
numnpCG = numnp;
numelCG = numel;
nen_bulk = 3;
Data{2} = [(1:numelCG)' NodesOnElement(1:numelCG,1:3)]; % overwrite the connectivity with the separated materials
for item = 1:nummat
    Mtext = MateData{2,item};
    % Find name of Set of elements assigned with this Section/Material
    for j = 1:size(MateData,2)
        if strcmp(Mtext,SectData{2,j})
            Stext = SectData{1,j};
            break
        end
    end
    % Find the data block for this set and update it
    for j = 1:Block %size(headerData,2)
        if strcmp(Stext,headerData{2,j}) && strcmp('*Elset',headerData{1,j})
            foundS = j;
            % Update the element ID for output to the Abaqus .inp to be 4
            % times as many elements
            elem1 = 4*(Data{foundS,1}(1)-1) + 1;
            elem2 = 4*Data{foundS,1}(end);
            Data{foundS,1} = (elem1:elem2)';
            break
        end
    end
end


%% Add the middle nodes from inside the T3 patches
Data{1} = [(1:numnpCG)' Coordinates(1:numnpCG,1:2)]; % overwrite the connectivity with the separated materials


%% Generate CZM interface in upper right material only
InterTypes = [0 0 0
              1 1 0
              1 1 0]; % only put CZM between the element edges between materials 1-2
DEIProgram2


%% Update all lists of nodes, for each BC list
numBC = length(NodeBCholder);

BCMaterials = [2 3 3 1 3];              % The region number that a BC is applied to
if length(BCMaterials) ~= numBC
    error('Need to specify an array for what material/region each BC is applied to')
end
for item = 1:numBC
    BCtext = BCData{1,item};
    for j = 1:Block %size(headerData,2)
        if strcmp(BCtext,headerData{2,j}) && strcmp('*Nset',headerData{1,j})
            foundBC = j;
            BCmat = BCMaterials(item);
            % Update the nodal ID for output to the Abaqus .inp file that have
            % updates for duplications.
            [Data{foundBC,1},~] = UpdateNodeSet(BCmat,RegionOnElement,ElementsOnNodeNum,...
                 ElementsOnNode,ElementsOnNodeDup,NodeBCholder{item},length(NodeBCholder{item}));
            [NodeBCholder{item},~] = UpdateNodeSet(BCmat,RegionOnElement,ElementsOnNodeNum,...
                 ElementsOnNode,ElementsOnNodeDup,NodeBCholder{item},length(NodeBCholder{item}));
            break
        end
    end
end


%% Commands to run in FEA_Program
NodeBC = [NodeBCholder{1}; NodeBCholder{2}; NodeBCholder{3}; NodeBCholder{4}; NodeBCholder{5}];
numBC = size(NodeBC,1);
MateT = zeros(3,3);
MateT(1,:) = [29000., 0.3 1];
MateT(2,:) = [29000., 0.3 1];
MateT(3,:) = [29000., 0.3 1];
SHist = 1;


%% Generate DG elements: create new elements in ix with format expected by
% Remove the elements for the notch and leave as a separate surface
InterTypes = [0 0 0
              1 1 0
              0 1 0]; % only put CZM between the element edges between materials 1-2

numSI = 0;
nummatCG = nummat;
% Interface region information: [materialID in MateT; mat1; mat2; regI; first coupler number; last coupler number]
RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);
for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        numSI = numSI + numSIi;
        numel_old = numel;
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                7,0,[100000 3 0.2],MatTypeTable,MateT);
        if numel > numel_old
        RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
        end
        end
    end
end
RegionsOnInterface = RegionsOnInterface(1:nummat-nummatCG,:);


%% Commands to run in FEA_Program
ProbType = [numnp numel nummat 2 2 nen];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;


%% Update the connectivity of solid elements to account for duplicated nodes
Data{2} = [(1:numelCG)' NodesOnElement(1:numelCG,1:3)]; % overwrite the connectivity with the separated materials


%% Add the data for the cohesive elements into the data for the problem
NodesCZM = [(numnpCG+1:numnp)' Coordinates(numnpCG+1:numnp,:)]; % new duplicated nodes

numinter = size(RegionsOnInterface,1);
ElsetCZM = cell(numinter,1); % new element sets for CZM
NodesOnElementCZM = cell(numinter,1); % new CZM elements
eltypeCZM = cell(2,numinter); % element type and material number
MateCZM = cell(numinter,1); % this is where all the text for the material stuff goes

for inter = 1:numinter
    reg1 = RegionsOnInterface(inter,2);
    reg2 = RegionsOnInterface(inter,3);
    coup1 = RegionsOnInterface(inter,5);
    coup2 = RegionsOnInterface(inter,6);
    ElsetCZM{inter} = (coup1:coup2)'; % new element set for CZM
    NodesOnElementCZM{inter} = [ElsetCZM{inter} NodesOnElement(ElsetCZM{inter},1:nen)]; % new CZM elements
    eltypeCZM{1,inter} = 'COH2D4'; % element type
    eltypeCZM{2,inter} = size(MateData,2)+1; % Material number; can also be an ACTIVE, existing material name
    % Here, the user could set the properties to depend upon reg1 and reg2
    % values; currently, they are the same for interfaces and intrafaces
    Mateczmstr{1} = '*Damage Initiation, criterion=MAXS';
    Mateczmstr{2} = '1.0e7,1.0e7,1.0e7';
    Mateczmstr{3} = '*Damage Evolution, type=DISPLACEMENT';
    Mateczmstr{4} = ' 0.2,';
    Mateczmstr{5} = '*Elastic, type=TRACTION';
    Mateczmstr{6} = '10000.,10000.,10000.';
    MateCZM{inter} = Mateczmstr; % this is where all the text for the material stuff goes
end
% % Find which couplers are between regions 2 and 3: [6,2,3,5,895,900]
% [matID,reg1,reg2,regI,coup1,coup2] = GetCouplersIntRegions(2,3,RegionsOnInterface);

%% Write the output .inp file
AbaqOut = 'PlateCOHNotch.inp';
DGCZMflag = 1; % turn on addition of CZM stuff
AbaqusInputWriter
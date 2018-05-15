% Tim Truster
% 04/9/2016
%
% Conversion file for Abaqus input for cracked plate problem
%
% Conversion of 4 noded elements into 3 noded elements, demonstrating where
% to modify data in order to write it back to a .inp file.

clear
% clc
NCR = 1;

%% Read in the .inp file
ndm = 2;
Abaqfile = 'PlateTest.inp';
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


%% Write the output .inp file
AbaqOut = 'PlateQ4T3.inp';
AbaqusInputWriter


%% Commands to run in FEA_Program
NodeBC = [NodeBCholder{1}; NodeBCholder{2}; NodeBCholder{3}; NodeBCholder{4}; NodeBCholder{5}];
numBC = size(NodeBC,1);
MateT = zeros(3,3);
MateT(1,:) = [29000., 0.3 1];
MateT(2,:) = [29000., 0.3 1];
MateT(3,:) = [29000., 0.3 1];
ProbType = [numnp numel nummat 2 2 nen];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

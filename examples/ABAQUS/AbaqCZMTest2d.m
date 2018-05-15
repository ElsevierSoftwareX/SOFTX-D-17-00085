% Demonstration of Abaqus reader/writer for 2d quadrilateral mesh.
% Domain: 10x1 rectangle
% Loading: Prescribed displacement of 0.2 on right edge.
%   CZM couplers between left 4 and right 6 elements
%
% Last revision: 12/09/2015 TJT

clear
% clc

Abaqfile = 'Solid2d.inp';
ndm = 2;
AbaqusInputReader

NodeBC = [NodeBCholder{1}; NodeBCholder{2}; NodeBCholder{3}; NodeBCholder{4}];
NodeBC(10:12,3) = 0.06; % change magnitude of prescribed displacement for Matlab model
numBC = size(NodeBC,1);

MateT = zeros(2,3);
MateT(1,:) = [100 .25 1];
MateT(2,:) = [100 .25 1];

% Insert CZM elements

% Insert CZM elements
numnpCG = numnp;
numelCG = numel;
nen_bulk = 4;
InterTypes = [0 0
              1 0];
DEIProgram2

numSI = 0;
for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        numSI = numSI + numSIi;
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                7,0,[100000 3 0.2],MatTypeTable,MateT);
        end
    end
end

ProbType = [numnp numel nummat 2 2 nen];

% Write output file
AbaqOut = 'Solid2dPlusCZM.inp';
DGCZMflag = 1; % turn on addition of CZM stuff
Data{2}(1:numelCG,2:nen_bulk+1) = NodesOnElement(1:numelCG,1:nen_bulk); % overwrite the connectivity with the separated materials
NodesCZM = [(numnpCG+1:numnp)' Coordinates(numnpCG+1:numnp,:)]; % new duplicated nodes
ElsetCZM{1} = (numelCG+1:numel)'; % new element set for CZM
NodesOnElementCZM{1} = [ElsetCZM{1} NodesOnElement(ElsetCZM{1},1:nen)]; % new CZM elements
eltypeCZM{1,1} = 'COH2D4'; % element type
eltypeCZM{2,1} = 3; % Material number; can also be an ACTIVE, existing material name
Mateczmstr{1} = '*Damage Initiation, criterion=MAXS';
Mateczmstr{2} = '3.,3.,3.';
Mateczmstr{3} = '*Damage Evolution, type=DISPLACEMENT';
Mateczmstr{4} = ' 0.2,';
Mateczmstr{5} = '*Elastic, type=TRACTION';
Mateczmstr{6} = '100000.,100000.,100000.';
MateCZM{1} = Mateczmstr; % this is where all the text for the material stuff goes
AbaqusInputWriter
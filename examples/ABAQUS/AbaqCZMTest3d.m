% Demonstration of Abaqus reader/writer for 3d hexahedral mesh.
% Domain: Two 1x1x1 cubes stacked in y direction
% Loading: Prescribed displacement of 0.2 on top surface.
%   One CZM coupler is inserted between them. Max stress = 3 occurs at
%   displacement = ~0.06 and then unloading happens after that.
%   Matlab version reset to capture the elastic solution up to 0.06 before
%   the delamination begins.
%
% Last revision: 12/09/2015 TJT

clear
% clc

Abaqfile = 'Solid3d.inp';
ndm = 3;
AbaqusInputReader

NodeBC = [NodeBCholder{1}; NodeBCholder{2}; NodeBCholder{3}; NodeBCholder{4}; NodeBCholder{5}; NodeBCholder{6}];
NodeBC(9:12,3) = 0.06; % change magnitude of prescribed displacement for Matlab model
numBC = size(NodeBC,1);

MateT = zeros(2,3);
MateT(1,:) = [100 .25 1];
MateT(2,:) = [100 .25 1];

% Insert CZM elements
numnpCG = numnp;
numelCG = numel;
nen_bulk = 8;
InterTypes = [0 0
              1 0];
DEIProgram3

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
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,3,numel,nummat,6, ...
                7,0,[100000 3 0.2],MatTypeTable,MateT);
        end
    end
end

% Update boundary conditions; none are near the interface

ProbType = [numnp numel nummat 3 3 nen];

% Plot the solution field after the Matlab analysis
% plotNodeCont3(Coordinates+10*Node_U_V,StreList(2,:,:)',NodesOnElement,3,(1:size(NodesOnElement,1)-numSI))

% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

% Write output file
AbaqOut = 'Solid3dPlusCZM.inp';
DGCZMflag = 1; % turn on addition of CZM stuff
Data{2}(1:numelCG,2:nen_bulk+1) = NodesOnElement(1:numelCG,1:nen_bulk); % overwrite the connectivity with the separated materials
NodesCZM = [(numnpCG+1:numnp)' Coordinates(numnpCG+1:numnp,:)]; % new duplicated nodes
ElsetCZM{1} = (numelCG+1:numel)'; % new element set for CZM
NodesOnElementCZM{1} = [ElsetCZM{1} NodesOnElement(ElsetCZM{1},1:nen)]; % new CZM elements
eltypeCZM{1,1} = 'COH3D8'; % element type
eltypeCZM{2,1} = 3; % Material number; can also be an ACTIVE, existing material name
Mateczmstr{1} = '*Damage Initiation, criterion=MAXS';
Mateczmstr{2} = '3.,3.,3.';
Mateczmstr{3} = '*Damage Evolution, type=DISPLACEMENT';
Mateczmstr{4} = ' 0.2,';
Mateczmstr{5} = '*Elastic, type=TRACTION';
Mateczmstr{6} = '100000.,100000.,100000.';
MateCZM{1} = Mateczmstr; % this is where all the text for the material stuff goes
AbaqusInputWriter
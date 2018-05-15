% Demonstration of Gmsh reader for 3d tetrahedral mesh.
% Generated using Neper program: http://neper.sourceforge.net/.
% Polycrystalline domain consisting of 10 grains. 
% DG couplers are inserted between each grain.
% Domain: 1x1x1 block
%
% Last revision: 05/07/2018 TJT

clear
% clc

% Read in the .inp file
Gmshfile = 'n10-id1_noCZ.msh';
ndm = 3;
GmshInputReader

% BCs -  for patch test
nodexm = find(abs(Coordinates(:,1)-0)<1e-8);
nodexp = find(abs(Coordinates(:,1)-10)<1e-8);
nodeym = find(abs(Coordinates(:,2)-0)<1e-8);
nodezm = find(abs(Coordinates(:,3)-0)<1e-8);
NodeBC = [nodexm 1*ones(length(nodexm),1) 0*ones(length(nodexm),1)
          nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodeym 2*ones(length(nodeym),1) 0*ones(length(nodeym),1)
          nodezm 3*ones(length(nodezm),1) 0*ones(length(nodezm),1)];
numBC = length(NodeBC);

MateT = ones(nummat,1)*[100 .25 1]; % GPa
MatTypeTable = [1:nummat
                ones(1,nummat)];

% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
nenCG = nen;
nummatCG = nummat;
InterTypes = tril(ones(nummat),-1);

DEIProgram3

% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateNodeSet(0,RegionOnElement,ElementsOnNodeNum,...
                               ElementsOnNode,ElementsOnNodeDup,NodeBCCG,numBCCG);

numelCG = numel;
nen_bulk = nen;
SurfacesI = zeros(0,8);
numSI = 0;
RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);
for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
        numSI = numSI + numSIi;
        if numSIi > 0
            numSIi;
        end
        numel_old = numel;
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,3,numel,nummat,6, ...
                7,0,[100000 3 0.2],MatTypeTable,MateT);
        if numel > numel_old
        RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
        end
        end
    end
end
RegionsOnInterface = RegionsOnInterface(1:nummat-nummatCG,:);
ProbType = [numnp numel nummat 3 3 nen];

stepmax = 1;
SHist = 1;

%% Add the data for the cohesive elements into the data for the problem
% NodesCZM = [(numnpCG+1:numnp)' Coordinates(numnpCG+1:numnp,:)]; % new duplicated nodes

numinter = size(RegionsOnInterface,1);
ElsetCZM = cell(numinter,1); % new element sets for CZM
NodesOnElementCZM = cell(numinter,1); % new CZM elements
eltypeCZM = cell(2,numinter); % element type and material number
% MateCZM = cell(numinter,1); % this is where all the text for the material stuff goes

for inter = 1:numinter
    reg1 = RegionsOnInterface(inter,2);
    reg2 = RegionsOnInterface(inter,3);
    coup1 = RegionsOnInterface(inter,5);
    coup2 = RegionsOnInterface(inter,6);
    ElsetCZM{inter} = (coup1:coup2)'; % new element set for CZM
    NodesOnElementCZM{inter} = NodesOnElement(ElsetCZM{inter},1:nen); % new CZM elements
    eltypeCZM{1,inter} = -1; % element type
    eltypeCZM{2,inter} = RegionsOnInterface(inter,1); % Material number; can also be an ACTIVE, existing material name
end
% % Find which couplers are between regions 2 and 3: [13,2,3,5,1589,1606]
% [matID,reg1,reg2,regI,coup1,coup2] = GetCouplersIntRegions(2,3,RegionsOnInterface);


% Write output file
GmshOut = 'n10-id1_wCZ.msh';
DGCZMflag = 1; % turn on addition of CZM stuff
updateSolid = 1; % overwrite the connectivity with the separated materials
GmshInputWriter
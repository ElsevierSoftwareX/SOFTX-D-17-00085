% Test for pyramid element with CZ
% Domain: 6 pyramid elements and one brick
% Loading: Nodal forces on top face.
%
% Last revision: 05/09/2018 TJT

clear
% clc

% % uniform coordinates
% Coordinates = [0 0 0
%                2 0 0
%                2 2 0
%                0 2 0
%                0 0 2
%                2 0 2
%                2 2 2
%                0 2 2
%                1 1 1];
% unequal coordinates
Coordinates = [0 0 0
               2 0 0
               2 1 0
               0 1 0
               0 0 3
               2 0 3
               2 1 3
               0 1 3
               1.1 .4 1.6
               0 0 4
               2 0 4
               2 1 4
               0 1 4]; % perturbed center node
%                1 .5 1.5];
NodesOnElement = [1 2 3 4 9 0 0 0
                  1 5 6 2 9 0 0 0
                  2 6 7 3 9 0 0 0
                  3 7 8 4 9 0 0 0
                  4 8 5 1 9 0 0 0
                  5 8 7 6 9 0 0 0
                  5 6 7 8 10 11 12 13];
RegionOnElement = [1 1 1 2 2 2 3]';
numel = 7;
numnp = 13;
nen = 8;
NodeBC = [1 3 0
          2 3 0
          3 3 0
          4 3 0
          1 2 0
          2 2 0
          5 2 0
          6 2 0
          1 1 0
          4 1 0
          5 1 0
          8 1 0];
numBC = length(NodeBC);
numNodalF = 4;
NodeLoad = [10 3 2
            11 3 2
            12 3 2
            13 3 2];

MatTypeTable = [1 2 3
                1 1 1];
young = 100;
pois = .25;
thick = 1;
MateT = [young pois thick
         young pois thick
         young pois thick];
nummat = 3;
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 0;
SEHist = 1;
        
InterTypes = [0 0 0
              1 0 0
              1 1 0];
DEIProgram3

CZprop =100000;
iel = 7;
ndm = 3;
nonlin = 0;
nummatCG = nummat;
numSI = numCL;
numelCG = numel;
nen_bulk = nen;
SurfacesI = zeros(0,8);
numSI = 0;
% Interface region information: [materialID in MateT; mat1; mat2; regI; first coupler number; last coupler number]
RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);

for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = GetRegionsInt(mat1,mat2);
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
        numSI = numSI + numSIi;
        numel_old = numel;
%         if usemany
%             CZprop = CZpropall{matI};
%         end
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,ndm,numel,nummat,6, ...
                iel,nonlin,CZprop,MatTypeTable,MateT);
        if numel > numel_old
        RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
        end
        end
    end
end
RegionsOnInterface = RegionsOnInterface(1:nummat-nummatCG,:);

ProbType = [numnp numel nummat 3 3 nen];

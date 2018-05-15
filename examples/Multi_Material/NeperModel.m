% Demonstration of Abaqus reader for 3d tetrahedral mesh.
% Generated using Neper program: http://neper.sourceforge.net/.
% Polycrystalline domain consisting of 32 grains; 8 sets of macro-grains
% exist with 4 inside of each. DG couplers are inserted between each
% macro-grain, as well as between sub-grains of macro-grains 1 and 4. These
% designations may be changed by the user in the list IntraGrainList.
% Domain: 1x1x1 block
%
% Last revision: 10/28/2017 TJT

clear
% clc

% Read in the .inp file
Abaqfile = 'NeperModel.inp';
ndm = 3;
AbaqusInputReader

% Assign grain ID to the elements in the grain; grains are listed as
% "polyX", after the first two data blocks
nummat = 32;
nummatG = nummat/4;
nummatA = nummat;
for grain = 1:32
    elset = Data{2+grain,1};
    RegionOnElement(elset) = grain; %#ok<SAGROW>
end

% BCs -  for patch test
nodexm = find(abs(Coordinates(:,1)-0)<1e-8);
nodexp = find(abs(Coordinates(:,1)-1)<1e-8);
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
InterTypes = zeros(nummat);
for grain1 = 1:nummatG
    for sub1 = 1:4
        mat1 = 4*(grain1-1)+sub1;
        for grain2 = 1:grain1-1
            for sub2 = 1:4
                mat2 = 4*(grain2-1)+sub2;
                InterTypes(mat1,mat2) = 1;
            end
        end
    end
end
IntraGrainList = [1 4];
for grain = 1:length(IntraGrainList)
    grain1 = IntraGrainList(grain);
    for sub1 = 2:4
        mat1 = 4*(grain1-1)+sub1;
        grain2 = grain1;
            for sub2 = 1:sub1-1
                mat2 = 4*(grain2-1)+sub2;
                InterTypes(mat1,mat2) = 1;
            end
    end
end

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
for mat2 = 1:nummatA
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
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormDG(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,3,numel,nummat,6, ...
                8,0,0,MatTypeTable,MateT);
        end
    end
end
ProbType = [numnp numel nummat 3 3 nen];

stepmax = 1;

% After analysis, compare the displacement at a duplicated node on the
% interior of the domain:
% NodeTable([4366,7090],:)
% ans =
%    0.857559489266000   0.036174547925000   0.137010822411000
%    0.857559489266000   0.036174547925000   0.137010822411000
% Node_U_V([4366,7090],:)
% ans =
%    0.085755948926601  -0.000904363698125  -0.003425270560275
%    0.085755948926601  -0.000904363698125  -0.003425270560275
